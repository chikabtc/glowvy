const path = require("path");
const fs = require("fs");
const directoryPath = path.join(__dirname, "files");
const fetch = require("node-fetch");


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

function writeJsonToFile(path, data) {
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
module.exports = {
    sleep: sleep,
    uploadJsonFiles: uploadJsonFiles,
    writeJsonToFile: writeJsonToFile,
    deleteReviewsByUserId: deleteReviewsByUserId,
    uploadProductsToAlgolia: uploadProductsToAlgolia,
    getProductsByCategoryId: getProductsByCategoryId
}