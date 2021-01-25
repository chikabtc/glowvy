const path = require("path");
const fs = require("fs");
const directoryPath = path.join(__dirname, "files");
const fetch = require("node-fetch");
const {
    product
} = require("puppeteer");
const {
    trueDependencies
} = require("mathjs");


function sleep(ms) {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}

async function uploadProductsToAlgolia(db, categoryId) {

    const algoliasearch = require("algoliasearch");

    const client = algoliasearch("50G6MO803G", "ab5eb7ec7552bb7865f3819a2b08f462");
    const index = client.initIndex('cosmetics');
    // index.delete();
    // const contactsJSON = require('./contacts.json');
    var snap = await db.collection('products').where('category.first_category_id', '==', categoryId).get()
    console.log(`docs count: ${snap.docs.length}`);
    var productJson = [];

    for (const pro of snap.docs) {
        if (pro.data().description != null) {
            var product = pro.data()
            var productUpload = {
                'name': product.name,
                'official_price': product.official_price,
                'sprice': product.sprice,
                'sid': product.sid,
                'objectID': product.sid,
                'description': product.description,
                // 'sdescription': product.sdescription,
                'brand': product.brand,
                'category': product.category,
                'tags': product.tags,
                'review_metas': product.review_metas,
                'thumbnail': product.thumbnail

            }
            productJson.push(productUpload)
        }
    }


    index.saveObjects(productJson, {
        autoGenerateObjectIDIfNotExist: true
    }).then(({
        objectIDs
    }) => {
        console.log(objectIDs);
    });
}

async function deleteReviewsByUserId(db) {
    var uid = 'yyCpqGf5PRb9VGyoL6pdJDdl3fH3';
    var snap = await db.collection('reviews').where('user.uid', '==', uid).get()
    for (const pro of snap.docs) {
        pro.ref.delete()
    }
}

async function getProductsByCategoryId(db, categoryId) {
    var products = [];
    var snap = await db.collection('products').where('category.first_category_id', '==', categoryId).get();
    if (snap.empty) {
        console.log(`category id ${categoryId} is empty`);
    } else {
        console.log(`category id ${categoryId} count: ${snap.docs.length}`);
        for (const doc of snap.docs) {
            products.push(doc.data())
        }
    }
    return products;
}

function updateJsonTags() {

    //update tag json to tag string 
    // var snap = await db.collection('products').get()
    // for (const doc of snap.docs) {
    //   var product = doc.data()
    //   var tags = [];
    //   if (product.tags != null) {
    //     for (const tag of product.tags) {
    //       if (tag != null) {
    //         if (tag.hasOwnProperty('name')) {
    //           tags.push(tag.name)
    //         }
    //       }
    //     }
    //     doc.ref.update({
    //       "tags": tags
    //     }).then(() => console.log("updated"))
    //   }
}

// function uploadImgToStorage(url) {
//     const bucket = admin.storage().bucket('product_thumbnails');
//     const file = bucket.file('path/to/image.jpg');
//     // While the file names are the same, the references point to different files

//     fetch(url).then((res) => {
//         const contentType = res.headers.get('content-type');
//         const writeStream = file.createWriteStream({
//             metadata: {
//                 contentType,
//                 metadata: {
//                     myValue: 123
//                 }
//             }
//         });
//         res.body.pipe(writeStream);
//     }).then(() =>
//         //update product thumbnail url in the products collection
//     );
// }


function uploadJsonFiles(db) {
    fs.readdir(directoryPath, function (err, files) {
        if (err) {
            return console.log("Unable to scan directory: " + err);
        }

        files.forEach(function (file) {
            let fileName = file.substring(0, file.lastIndexOf("."));
            console.log(fileName)
            //1. make the obj id string
            //2. reupload the objects using 
            //3. delete the id property
            var menu = require("./files/" + file);
            menu.forEach(function (obj) {
                var productJson = {
                    'sid': obj.sid,
                    'name': obj.name,
                    'sname': obj.sname,
                    'description': obj.description,
                    'sdescription': obj.sdescription,
                }
            });
        });
    })
}

function writeJsonToFile(data, path) {
    fs.writeFile(path, JSON.stringify(data, null, 4), (err) => {
        if (err) {
            console.error(err);
            return;
        };
        console.log("File has been created");
    });
}

function uploadJsonFiles(db) {
    fs.readdir(directoryPath, function (err, files) {
        if (err) {
            return console.log("Unable to scan directory: " + err);
        }

        files.forEach(function (file) {
            let fileName = file.substring(0, file.lastIndexOf("."));
            console.log(fileName)
            //1. make the obj id string
            //2. reupload the objects using 
            //3. delete the id property
            var menu = require("./files/" + file);

            menu.forEach(function (obj) {
                var ingredients = obj.ingredients;
                delete obj.ingredients
                // console.log(obj)
                db
                    .collection('products')
                    .add(obj)
                    .then(function (res) {
                        console.log("Document written");
                        ingredients.forEach(async function (obj) {
                                await res.collection('ingredients').add(obj).then(() => console.log('uploaded ingredient'))
                            }
                            // console.log(typeof ingredientsJson)
                        )
                    })
                    .catch(function (error) {
                        console.error("Error adding document: ", error);
                    });
            });
        });
    })
}

async function updateProductCateBrandId() {
    const snapshot = await db.collection('products').get();
    if (snapshot.empty) {
        console.log('No matching documents.');
        return;
    }
    snapshot.forEach(async doc => {
        //get correct category id
        let product = doc.data();
        let categoryName = product.category.name;
        let brandName = product.brand.name;

        let categoryDoc = await db.collection('categories').doc(categoryName).get();
        let categoryId = categoryDoc.data().id;

        let brandDoc = await db.collection('brands').doc(brandName).get();
        let brandId = brandDoc.data().id;
        console.log(`cateID: ${categoryId} \n brandId: ${brandId}`);
        //get correct brand id 
        // console.log(doc.id, '=>', doc.data());
        doc.ref.update({
            'category.id': categoryId,
            'brand.id': brandId,
        }).then(() => console.log("document updated"))
    });
}

async function deleteProductsWithoutName(db) {
    console.log(count);
    var snap = await db.collection('products').get()
    // console.log(snap.docs.length);
    var count = 0;

    for (const doc of snap.docs) {
        var productJson = doc.data()
        if (productJson.name === '') {
            await doc.ref.delete(() => count++)

        }
    }
    console.log(count);
}
async function clearBrandTotalCount(db) {
    console.log('dw?')
    var snap = await db.collection('brands').get()
    console.log(snap.docs.length);
    for (const doc of snap.docs) {
        doc.ref.update({
            'grand_total_count': 0
        })
    }
}

async function clearCategoriesTotalCount(db) {
    var snap = await db.collection('categories').get()
    for (const doc of snap.docs) {
        var category = doc.data()
        var subCategories = category.sub_categories;
        // if (category.hasOwnProperty('grand_total_count')) {
        //   category.grand_total_count = 0
        // }

        //find the subcategories the product belongs to 
        if (subCategories != null) {
            for (const secondCate of subCategories) {
                secondCate.grand_total_count = 0
                if (secondCate.sub_categories != null) {
                    for (const thirdCate of secondCate.sub_categories) {
                        thirdCate.sub_categories = 0
                    }
                }
            }
        }
        // console.log(subCategories)

        await doc.ref.update({
            'grand_total_count': 0,
            'sub_categories': subCategories
        }).then(() => console.log('clearCategoriesTotalCount: success'))
    }
}

async function getLastestCategory(db) {
    if (category.first_category_id != undefined) {

        let categoryDoc = await db.collection('categories').where("id", '==', category.first_category_id).get();
        var glowvyCategory = categoryDoc.docs[0].data()

        let secondCate = glowvyCategory.sub_categories.find(element => element.id == category.second_category_id);

        var thirdCategory
        var secondCateSynonyms
        var firstCateSynonyms = category.first_category_synonyms;
        var thirdCateSynonyms

        if (secondCate != undefined) {
            thirdCategory = secondCate.sub_categories.find(element => element.id == category.third_category_id);
            secondCateSynonyms = secondCate.second_category_synonyms;
            // console.log(secondCateSynonyms)
        }

        if (thirdCategory != undefined) {
            thirdCateSynonyms = thirdCategory.third_category_synonyms;
            // console.log(thirdCateSynonyms)
        }
        var json = {
            'sid': productJson.sid,
            'first_category_en_name': glowvyCategory.en_name,
            'second_category_en_name': secondCate != undefined ? secondCate.en_name : null,
            'third_category_en_name': thirdCategory != undefined ? thirdCategory.en_name : null,
            'first_category_id': glowvyCategory.id,
            'second_category_id': secondCate != undefined ? secondCate.id : null,
            'third_category_id': thirdCategory != undefined ? thirdCategory.id : null,
            'first_category_name': glowvyCategory.name,
            'second_category_name': secondCate != undefined ? secondCate.name : null,
            'third_category_name': thirdCategory != undefined ? thirdCategory.name : null,
            'first_category_synonyms': firstCateSynonyms != undefined ? firstCateSynonyms : [],
            'second_category_synonyms': secondCateSynonyms != undefined ? secondCateSynonyms : [],
            'third_category_synonyms': thirdCateSynonyms != undefined ? thirdCateSynonyms : [],
        }
        return json
    }
}

async function updateBrandProductCount(db, productJson, incrementBy) {
    const snap = await db.collection('brands').where('id', '==', productJson.brand.id).get();
    const brandDoc = snap.docs[0];
    const count = brandDoc.data().grand_total_count + incrementBy;
    brandDoc.ref.update({
        grand_total_count: count,
    }).then(() => console.log('updateBrandProductCount: incremented'));
}

async function updateCategoryProductCount(db, productJson, incrementBy) {
    if (productJson.category.hasOwnProperty('first_category_id')) {
        const snap = await db.collection('categories').where('id', '==', productJson.category.first_category_id).get();
        const categoryDoc = snap.docs[0];
        const category = snap.docs[0].data();
        const subCategories = category.sub_categories;
        if (productJson.category.first_category_id !== undefined) {
            if (category.hasOwnProperty('grand_total_count')) {
                if (category.grand_total_count !== 0 || incrementBy !== -1) {
                    category.grand_total_count += incrementBy;
                }
            } else {
                category.grand_total_count = 1;
            }

            // find the subcategories the product belongs to
            if (subCategories != null) {
                if (productJson.category.second_category_id != null) {
                    const secondCate = category.sub_categories.find((cate) => cate.id === productJson.category.second_category_id);
                    const index = category.sub_categories.findIndex((cate) => secondCate.id === cate.id);
                    if (subCategories[index].hasOwnProperty('grand_total_count')) {
                        // if the count is zero, don't decrement
                        if (subCategories[index].grand_total_count !== 0 || incrementBy !== -1) {
                            subCategories[index].grand_total_count += incrementBy;
                        }
                    } else {
                        subCategories[index].grand_total_count = 1;
                    }

                    if (productJson.category.third_category_id != null) {
                        const thirdCategory = secondCate.sub_categories.find((cate) => cate.id === productJson.category.third_category_id);
                        const thirdIndex = secondCate.sub_categories.findIndex((cate) => thirdCategory.id === cate.id);
                        // eslint-disable-next-line no-plusplus
                        subCategories[index].sub_categories[thirdIndex].grand_total_count++;

                        if (subCategories[index].sub_categories[thirdIndex].hasOwnProperty('grand_total_count')) {
                            // if the count is zero, don't decrement

                            if (subCategories[index].sub_categories[thirdIndex].grand_total_count !== 0 || incrementBy !== -1) {
                                subCategories[index].sub_categories[thirdIndex].grand_total_count += incrementBy;
                            }
                        } else {
                            subCategories[index].sub_categories[thirdIndex].grand_total_count = 1;
                        }

                        // console.log(thirdCategory)
                    }
                }
            }
            // console.log(subCategories)

            await categoryDoc.ref.update({
                grand_total_count: category.grand_total_count,
                sub_categories: subCategories,
            }).then(() => console.log('updateCategoryProductCount: incremented'));
        }

    } else {
        console.log('no category')
        console.log(productJson.sid)

    }

}
async function isDuplicate(db, id) {
    const snap = await db.collection('products').where('sid', '==', id).get()
    if (snap.docs.length > 1) {
        // console.log(('du')) e
        return true;
    } else {
        return false;
    }
}

//should delete the ingredient collection as well
//better not delete products.. or just delete one product.
async function deleteDuplicateProducts() {
    const snap = await db.collection('products').get()
    for (const prod of newprods) {

        //   //1. check if the product is duplicate 
        if (await utils.isDuplicate(db, doc.data().sid)) {
            doc.ref.delete().then(() => console.log('deleted the first duplicate products'))

        }
    }
}


module.exports = {
    sleep: sleep,
    uploadJsonFiles: uploadJsonFiles,
    writeJsonToFile: writeJsonToFile,
    deleteReviewsByUserId: deleteReviewsByUserId,
    uploadProductsToAlgolia: uploadProductsToAlgolia,
    getProductsByCategoryId: getProductsByCategoryId,
    deleteProductsWithoutName: deleteProductsWithoutName,
    clearBrandTotalCount: clearBrandTotalCount,
    getLastestCategory: getLastestCategory,
    clearCategoriesTotalCount: clearCategoriesTotalCount,
    updateBrandProductCount: updateBrandProductCount,
    updateCategoryProductCount: updateCategoryProductCount,
    isDuplicate: isDuplicate,
}