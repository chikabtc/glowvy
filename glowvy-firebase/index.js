var admin = require("firebase-admin");
const path = require("path");
const fs = require("fs");
var serviceAccount = require("./service_key.json");
// const directoryPath = path.join(__dirname, "/utils/files/categories.json");
// var json = require(`${__dirname}/utils/files/categories.json`);
const axios = require('axios').default;
const fetch = require("node-fetch");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://glowvy-b6cf4.firebaseio.com"
});
const puppet = require('puppeteer');
var token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MDU1ODUwNjksImV4cCI6MTYwNTY3MTQ2OX0.3y6wDRJEEJ34fqV9Wk-B70-7ugofRL5hR9jDhNgB0rE'
const projectId = 'dimodo - 1585384547888';
const {
  Translate
} = require('@google-cloud/translate').v2;
const translate = new Translate({
  projectId

});
const algolia = require('algoliasearch');

const client = algolia.default('50G6MO803G', 'ab5eb7ec7552bb7865f3819a2b08f462');
const cosmeticsIndex = client.initIndex('cosmetics'); //

const db = admin.firestore();
const crawler = require("./crawler/glowpick");

const {
  firestore
} = admin;

const utils = require('./utils/utils');
const parser = require('./crawler/parser');
const glowpick = require("./crawler/glowpick");
const {
  BADNAME
} = require("dns");
const {
  prod
} = require("mathjs");
const {
  bohrRadiusDependencies
} = require("mathjs");
const {
  get
} = require("http");




function writeJsonToFile(path, json) {
  fs.writeFile(path, JSON.stringify(json, null, 4), (err) => {
    if (err) {
      console.error(err);
      return;
    };
    console.log("File has been created");
  });
}

// async function updateAvailableBrandCategories(product) {
//   // 1. get the brand doc
//   const brandSnap = await db.collection('brands').where('id', '==', product.brand.id).get();
//   const brandDoc = brandSnap.docs[0];
//   const brand = brandDoc.data();
//   console.log(`brand name ` + brand.name)
//   var firstCateIds = [];
//   var secondCateIds = [];
//   var thirdCateIds = [];

//   var prodCate = product.category
//   if (brand.hasOwnProperty('categories')) {
//     var brandCategories = brand.categories
//     for (const brandCate of brand.categories) {
//       firstCateIds.push(brandCate.id)
//       for (const secondCate of brandCate.second_categories) {
//         secondCateIds.push(secondCate.id)
//         for (const thirdCate of secondCate.third_categories) {
//           thirdCateIds.push(thirdCate.id)
//         }
//       }
//     }
//     console.log(firstCateIds + '\n' + secondCateIds + '\n' + thirdCateIds)
//     //1. if the first category id is not included, then add the whole category
//     if (!firstCateIds.includes(prodCate.first_category_id)) {
//       console.log('first category missing')


//       var category = {
//         id: prodCate.first_category_id,
//         name: prodCate.first_category_name,
//         second_categories: [{
//           id: prodCate.second_category_id,
//           name: prodCate.second_category_name,
//           third_categories: [{
//             id: prodCate.third_category_id,
//             name: prodCate.third_category_name,
//           }]
//         }]
//       }
//       brandCategories.push(category)
//     } else if (!secondCateIds.includes(prodCate.second_category_id)) {

//       console.log('second category missing')
//       var firstCateIndex = brandCategories.findIndex(cate => cate.id == prodCate.first_category_id)
//       console.log(firstCateIndex)
//       var firstCate = brandCategories[firstCateIndex]
//       console.log(firstCate)

//       firstCate.second_categories.push({
//         id: prodCate.second_category_id,
//         name: prodCate.second_category_name,
//         third_categories: [{
//           id: prodCate.third_category_id,
//           name: prodCate.third_category_name,
//         }]
//       })

//       brandCategories[firstCateIndex] = firstCate
//     } else if (!thirdCateIds.includes(prodCate.third_category_id)) {
//       console.log('third category missing')

//       var firstCateIndex = brandCategories.findIndex(cate => cate.id == prodCate.first_category_id)
//       var firstCate = brandCategories[firstCateIndex]
//       var secondCateIndex = firstCate.second_categories.findIndex(cate => cate.id == prodCate.second_category_id);
//       var secondCate = brandCategories[firstCateIndex].second_categories[secondCateIndex]

//       secondCate.third_categories.push({
//         id: prodCate.third_category_id,
//         name: prodCate.third_category_name,
//       })
//       firstCate.second_categories[secondCateIndex] = secondCate;
//       brandCategories[firstCateIndex] = firstCate
//     }
//     brandDoc.ref.update({
//       'categories': brandCategories
//     }).then(() => console.log('added category'))

//   } else {
//     console.log('no categories available on the brand doc')
//     brand.categories = [];
//     var category = {
//       id: prodCate.first_category_id,
//       name: prodCate.first_category_name,
//       second_categories: [{
//         id: prodCate.second_category_id,
//         name: prodCate.second_category_name,
//         third_categories: [{
//           id: prodCate.third_category_id,
//           name: prodCate.third_category_name,
//         }]
//       }]
//     }
//     var categories = [];
//     categories.push(category)
//     console.log(categories)
//     brandDoc.ref.update({
//       'categories': categories
//     }).then(() => console.log('added category'))
//   }
// }
(async () => {

  var snap = await db.collection('reviews').limit(100).get()
  console.log(snap.docs.length);
  db.settings({
    ignoreUndefinedProperties: true
  })
})().catch(e => {
  // Deal with the fact the chain failed
});

(async () => {

  var snap = await db.collection('reviews').limit(100).get()
  console.log(snap.docs.length);
  db.settings({
    ignoreUndefinedProperties: true
  })


  // ===========================================================================
  // add counter to the categories
  // ===========================================================================
  //1. loop through all products
  //2. increment the count to the categories


  // for (const doc of snap.docs) {
  //   var productJson = doc.data()
  //   //get the cateogry snap 
  //   if (productJson.category.first_category_id != undefined) {
  //     var snap = await db.collection('categories').where('id', '==', productJson.category.first_category_id).get()
  //     var categoryDoc = snap.docs[0]
  //     var category = snap.docs[0].data()
  //     var subCategories = category.sub_categories;
  //     category.grand_total_count++

  //     //find the subcategories the product belongs to 
  //     if (subCategories != null) {
  //       if (productJson.category.second_category_id != null) {
  //         const secondCate = category.sub_categories.find((category) => category.id === productJson.category.second_category_id);
  //         const index = category.sub_categories.findIndex((category) => secondCate.id == category.id)

  //         subCategories[index].grand_total_count++
  //         // console.log(secondCate)

  //         if (productJson.category.third_category_id != null) {
  //           const thirdCategory = secondCate.sub_categories.find((category) => category.id === productJson.category.third_category_id);
  //           const thirdIndex = secondCate.sub_categories.findIndex((category) => thirdCategory.id == category.id)
  //           subCategories[index].sub_categories[thirdIndex].grand_total_count++

  //           console.log(thirdCategory)

  //         }
  //       }
  //     }
  //     console.log(subCategories)

  //     // await categoryDoc.ref.update({
  //     //   'grand_total_count': category.grand_total_count,
  //     //   'sub_categories': subCategories
  //     // }).then(() => console.log('holooo'))
  //   }

  // }



  // ===========================================================================
  // update brands sub categories field names and the category name
  // ===========================================================================
  // var snap = await db.collection('brands').get()
  // if (!snap.empty) {
  //   for (const doc of snap.docs) {
  //     var brand = doc.data()
  //     if (brand.categories != null) {

  //       var firstCategories = [];
  //       //0. loop through the first categories
  //       for (const cate of brand.categories) {
  //         //get firstCate from categories collection
  //         var snap = await db.collection('categories').where('id', '==', cate.id).get()
  //         var officialCate = snap.docs[0].data();
  //         var firstCate = snap.docs[0].data();
  //         delete firstCate.sub_categories
  //         // delete officialCate.sub_categories

  //         //update category field name and name
  //         //1. create empty list

  //         if (cate.second_categories != null) {
  //           var secondCategories = [];
  //           //2. loop through second categories
  //           for (const secondCategory of cate.second_categories) {
  //             //3. find updated category 
  //             const secondCate = officialCate.sub_categories.find((category) => category.id === secondCategory.id);

  //             if (secondCategory.third_categories != null) {
  //               var thirdCategories = [];
  //               for (const thirdCategory of secondCategory.third_categories) {
  //                 //5. find the updated thirdCategory
  //                 var index = officialCate
  //                 const thirdCate = secondCate.sub_categories.find((category) => category.id === thirdCategory.id);
  //                 //6. add the cate to the thirdCategories array
  //                 thirdCategories.push(thirdCate)
  //               }
  //               //7. add the thirdCategories to the secondCategory
  //               secondCate.sub_categories = thirdCategories
  //             } else {
  //               delete secondCate.sub_categories
  //             }
  //             //8. add the secondCategory to the secondCategories
  //             secondCategories.push(secondCate)
  //           }
  //           firstCate.sub_categories = secondCategories;
  //         }

  //         //9. add the second categories to the first categories
  //         firstCategories.push(firstCate);
  //         // console.log(firstCate.name)
  //         // console.log(firstCate.sub_categories)
  //         // console.log(`${officialCate.name} \n`);
  //         // console.log(secondCategories)
  //       }
  //     }
  //     await doc.ref.update({
  //       'categoriess': firestore.FieldValue.delete(),
  //       'categories': firstCategories
  //     }).then(() => console.log('holooo'))
  //   }
  // }
  // ===========================================================================
  // add grandTotalCount to every brand document 
  // ===========================================================================

  //1. get all products
  //2. loop through each
  //3. update its' brand count 
  // var snap = await db.collection('products').get()
  // if (!snap.empty) {

  //   for (const doc of snap.docs) {
  //     var productDoc = doc;
  //     var brand = productDoc.data().brand
  //     console.log(brand)
  //     var snap = await db.collection('brands').where('id', '==', brand.id).get()
  //     var brandDoc = snap.docs[0];
  //     brandDoc.ref.update({
  //       grand_total_count: firestore.FieldValue.increment(1)
  //     }).then(() => console.log('incremented'))
  //   }
  // }

  // ===========================================================================
  // add like count to all review
  // ===========================================================================

  // var snap = await db.collection('reviews').get()
  // console.log(snap.docs.length);

  // for (const doc of snap.docs) {
  //   doc.ref.update({
  //     'like_count': 0,
  //   }).then(() => console.log('updatedreviews'))
  // }


  // ===========================================================================
  // update products categories info
  // ===========================================================================
  //1. update the categories collection
  // var menu = require("./crawled/categories.json");


  // menu.forEach(function (obj) {
  //   db
  //     .collection('categories')
  //     .doc(obj.en_name)
  //     .set(obj)
  //     .then(function (res) {
  //       console.log("Document written");

  //       // console.log(typeof ingredientsJson)

  //     })
  //     .catch(function (error) {
  //       console.error("Error adding document: ", error);
  //     });
  // });
  //2. get all products from firestores

  // var snap = await db.collection('products').get()
  // console.log(snap.docs.length);
  // var count = 0
  // for (const doc of snap.docs) {
  //   var productJson = doc.data()
  //   var category = productJson.category;
  //   // console.log(category);
  //   if (category.first_category_id != undefined) {

  //     let categoryDoc = await db.collection('categories').where("first_category_id", '==', category.first_category_id).get();
  //     var glowvyCategory = categoryDoc.docs[0].data()

  //     let secondCate = glowvyCategory.second_categories.find(element => element.second_category_id == category.second_category_id);



  //     var thirdCategory
  //     var secondCateSynonyms
  //     var firstCateSynonyms = category.first_category_synonyms;
  //     var thirdCateSynonyms

  //     if (secondCate != undefined) {
  //       thirdCategory = secondCate.third_categories.find(element => element.third_category_id == category.third_category_id);
  //       secondCateSynonyms = secondCate.second_category_synonyms;
  //       console.log(secondCateSynonyms)
  //     }

  //     if (thirdCategory != undefined) {
  //       thirdCateSynonyms = thirdCategory.third_category_synonyms;
  //       console.log(thirdCateSynonyms)
  //     }


  //     try {

  //       doc.ref.update({
  //         'category.first_category_name': glowvyCategory.first_category_name,
  //         'category.second_category_name': secondCate != undefined ? secondCate.second_category_name : null,
  //         'category.third_category_name': thirdCategory != undefined ? thirdCategory.third_category_name : null,
  //         'category.first_category_synonyms': firstCateSynonyms != undefined ? firstCateSynonyms : [],
  //         'category.second_category_synonyms': secondCateSynonyms != undefined ? secondCateSynonyms : [],
  //         'category.third_category_synonyms': thirdCateSynonyms != undefined ? thirdCateSynonyms : [],
  //         'second_category_synonyms': firestore.FieldValue.delete(),
  //         'third_category_synonyms': firestore.FieldValue.delete(),
  //       }).then(() => console.log('successfully updated'))
  //     } catch (error) {
  //       console.log(secondCate)
  //       console.log(thirdCategory)
  //       console.log(error);

  //     }


  //   } else {
  //     count++
  //   }
  // }
  // console.log(`total wrong cate format: ${count}`);

  // ===========================================================================
  // update existing reviewer's info: add birthyear, add gender, and add skin type
  // ===========================================================================
  // ===========================================================================
  // update missing names
  // ==========================================================================
  // var snap = await db.collection('reviews').get()
  // console.log(snap.docs.length);

  // for (const doc of snap.docs) {
  //   var reviewJson = doc.data()
  //   if (doc.data().user.skin_type_id === 1) {
  //     doc.ref.update({
  //       'user.skin_type': '',
  //     }).then(() => console.log('updated sensitive skin type'))
  //   } else {
  //     // doc.ref.update({
  //     //   'user.birth_year': 2020 - reviewJson.user.age,
  //     //   'user.gender': 'Nữ',
  //     // }).then(() => console.log('upadted normal skintyp'))
  //   }
  // }
  // var products = require("./crawled/products.json");
  // console.log(products.length)

  // var count = 0

  // products.forEach(async function (obj) {

  //   var snap = await db.collection('products').where('sid', '==', obj.sid).get()
  //   if (!snap.empty) {
  //     var productDoc = snap.docs[0];
  //     if (obj.name !== '') {
  //       count++

  //       console.log(obj.name);
  //       productDoc.ref.update({
  //           'name': obj.name
  //         })
  //         .then(() => console.log('party'))
  //     }
  //   }
  // })
  // console.log(count)
  //   // delete obj.ingredients
  //   // console.log(obj)

  // });
  // var count = 0

  // var snap = await db.collection('products').get()
  // var count = 0
  // var products = [];

  // for (const doc of snap.docs) {
  //   var productJson = doc.data()
  //   if (doc.data().name == '') {
  //     count++
  //     console.log(doc.data().sid)
  //     var toTranslate = {
  //       'sid': productJson.sid,
  //       'name': productJson.name,
  //       'sname': productJson.sname,
  //       'description': productJson.description,
  //       'sdescription': productJson.sdescription,
  //       'category': productJson.category,
  //       'brand': productJson.brand
  //     }
  //     products.push(toTranslate)
  //   }
  // }
  // utils.writeJsonToFile('./crawled/missing_name_products.json', products)
  // console.log(count)



  // ===========================================================================
  // fix ranking score field
  // ===========================================================================
  // // console.log(Date.now())
  // var snap = await db.collection('products').get()
  // console.log(snap.docs.length)
  // //fix the brand id
  // var count = 0
  // for (const doc of snap.docs) {
  //   var reviewMetas = doc.data().review_metas
  //   if (reviewMetas.all.hasOwnProperty('ranking_scroe')) {
  //     // console.log('wrong')
  //     // count++

  //     doc.ref.update({
  //       'reviewMetas.all.ranking_scroe': firestore.FieldValue.delete(),
  //       'reviewMetas.complex.ranking_scroe': firestore.FieldValue.delete(),
  //       'reviewMetas.dry.ranking_scroe': firestore.FieldValue.delete(),
  //       'reviewMetas.neutral.ranking_scroe': firestore.FieldValue.delete(),
  //       'reviewMetas.oily.ranking_scroe': firestore.FieldValue.delete(),
  //       'reviewMetas.sensitive.ranking_scroe': firestore.FieldValue.delete(),
  //     }).then(() => console.log('added category'))
  //   }

  // }
  // console.log(count)
  // ===========================================================================
  // add created date to products
  // ===========================================================================
  // // console.log(Date.now())
  // var snap = await db.collection('products').get()
  // console.log(snap.docs.length)
  // //fix the brand id
  // for (const doc of snap.docs) {
  //   doc.ref.update({
  //     'created_at': Date.now()
  //   }).then(() => console.log('added category'))
  // }

  // ===========================================================================
  // 1. fix the brand id -> use the brand id in the brands collection
  // update brand's categories 
  // ===========================================================================


  // var snap = await db.collection('products').get()
  // console.log(snap.docs.length)
  // //fix the brand id
  // for (const doc of snap.docs) {
  //   console.log(`product sid ` + doc.data().sid)
  //   if (doc.data().brand.img != null) {
  //     doc.ref.update({
  //       'brand.image': doc.data().brand.img
  //     }).then(() => console.log('added category'))
  //   }
  // }







  // var snap = await db.collection('brands').get()
  // console.log(snap.docs.length)
  // for (const doc of snap.docs) {
  //   try {
  //     var product = doc.data();
  //     doc.ref.update({
  //       'img': firestore.FieldValue.delete()
  //     }).then(() => console.log('uu'))
  //   } catch (error) {
  //     console.log(error)

  //   }


  // }
  // ===========================================================================
  // add missing product field to the algolia
  // ===========================================================================



  // var snap = await db.collection('products').where('category.first_category_id', '==', 8).get()
  // console.log(snap.docs.length)
  // for (const doc of snap.docs) {
  //   try {
  //     var product = doc.data();
  //     const algoliaRecrod = {
  //       name: product.name,
  //       sprice: product.sprice,
  //       sid: product.sid,
  //       objectID: product.sid,
  //       description: product.description,
  //       volume: product.volume,
  //       // desc_images: product.desc_images,
  //       hazard_level: product.hazard_score,
  //       // 'sdescription': product.sdescription,
  //       brand: product.brand,
  //       category: product.category,
  //       tags: product.tags,
  //       review_metas: product.review_metas,
  //       thumbnail: product.thumbnail,
  //     };
  //     cosmeticsIndex.saveObject(algoliaRecrod).then(() => console.log('uu'));
  //   } catch (error) {
  //     console.log(error)

  //   }


  // }



  // ===========================================================================
  // crwal missing product thumbnail
  // ===========================================================================
  // var snap = await db.collection('products').where('review_metas.all.review_count', '>', 0).get()
  // console.log(snap.docs.length);

  // snap.docs.forEach(async function (obj) {
  //   // http://storage.googleapis.com/glowvy-b6cf4.appspot.com/product/thumbnail/thumbnail_1525228639568.jpg

  //   var token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MDU5NDQ0OTcsImV4cCI6MTYwNjAzMDg5N30.OO0RRPydlNS3TTdcUhN4NtdFu5ZaXtIeh-8QQzBPJt8';
  //   let url = `
  // https://api-j.glowpick.com/api/product/${obj.data().sid}`;
  //   console.log(url)
  //   await axios.get(url, {
  //     headers: {
  //       "Authorization": `Bearer ${token}`
  //     }
  //   }).then(async response => {

  //       let product = response.data.data;
  //       const bucket = admin.storage().bucket('glowvy-b6cf4.appspot.com');
  //       const file = bucket.file(`product/thumbnail/thumbnail_${obj.data().sid}.jpg`);
  //       const writeStream = file.createWriteStream();
  //       var thumbnailURL = product.productImg
  //       console.log(thumbnailURL)


  //       await fetch(thumbnailURL).then((res) => {
  //         const contentType = res.headers.get('content-type');
  //         const writeStream = file.createWriteStream({
  //           metadata: {
  //             contentType,
  //           }
  //         });
  //         res.body.pipe(writeStream);
  //         console.log("uploaded file successfully")

  //       }).catch((e) => console.log(`error uploadFile: ${e}`));;

  //     }
  //     // //get translated tags from the db?
  //   )
  // });



  // ===========================================================================
  // update firestore review timesstamp to int 
  // ===========================================================================
  // var snap = await db.collection('reviews').get()

  // for (const doc of snap.docs) {
  //   var timestamp = doc.data().created_at
  //   if (typeof timestamp.toMillis === 'function') {
  //     var dateInt = timestamp.toMillis()
  //     doc.ref.update({
  //       'created_at': dateInt,
  //     }).then(() => console.log('uu'))
  //   }
  // }
  // ===========================================================================
  // update ingredient collection field name from purpose_vi string to purposes list
  // ===========================================================================
  // var snap = await db.collection('ingredients').get()
  // console.log(snap.docs.length)
  // // var count = 0

  // for (const doc of snap.docs) {
  //   //get ingredients
  //   if (doc.data().purpose_vi != null) {
  //     var purposes = doc.data().purpose_vi.split(',')
  //     // console.log(`ingredient purpose length: ${purposes.length}`);
  //   }
  //   doc.ref.update({
  //     // 'product.sid': doc.data().product_id,
  //     // 'user.skin_type_en': doc.data().user.skin_type,
  //     // 'user.skin_type': viSkinType,
  //     'purposes': purposes,
  //     'purpose_vi': firestore.FieldValue.delete()
  //   }).then(() => console.log('uu'))

  // }
  // ===========================================================================
  // update product ingredient field name from purposes_vi string to purposes list
  // ===========================================================================
  // var snap = await db.collection('products').where('review_metas.all.review_count', '==', 0).get()
  // console.log(snap.docs.length)
  // // var count = 0

  // for (const doc of snap.docs) {
  //   //get ingredients
  //   var ingredients = await doc.ref.collection('ingredients').get()
  //   for (const doc of ingredients.docs) {
  //     if (doc.data().purpose_vi != null) {
  //       var purposes = doc.data().purpose_vi.split(',')
  //       // console.log(`ingredient purpose length: ${purposes.length}`);
  //     }
  //     doc.ref.update({
  //       // 'product.sid': doc.data().product_id,
  //       // 'user.skin_type_en': doc.data().user.skin_type,
  //       // 'user.skin_type': viSkinType,
  //       'purposes': purposes,
  //       'purpose_vi': firestore.FieldValue.delete()
  //     }).then(() => console.log('uu'))


  //   }

  // }
  // console.log(count)
  // // ===========================================================================
  // add missing product.sid in the reviews
  // add missing user skin in Vietnamese 
  // ===========================================================================
  // var snap = await db.collection('reviews').get()
  // console.log(snap.docs.length)
  // var count = 0

  // for (const doc of snap.docs) {
  //   if (doc.data().product_id != null) {
  //     // count++
  //     var viSkinType = translateSkinTypeToVi(doc.data().user.skin_type)
  //     doc.ref.update({
  //       // 'product.sid': doc.data().product_id,
  //       // 'user.skin_type_en': doc.data().user.skin_type,
  //       // 'user.skin_type': viSkinType,
  //       'product_id': firestore.FieldValue.delete()
  //     }).then(() => console.log('uu'))
  //   }
  // }
  // console.log(count)
  // ===========================================================================
  // Update the sprice of the products
  // ===========================================================================
  // var snap = await db.collection('products').where('price', '>', 0).get()
  // for (const doc of snap.docs) {
  //   //1. get the products with description and review count is zero 
  //   doc.ref.update({
  //     sprice: doc.data().price
  //   }).then(() => console.log('uu'))
  //   // console.log(snap.docs.length)
  // }
  // ===========================================================================
  // Delete the ingredients field from product document
  // ===========================================================================
  // var snap = await db.collection('reviews').where('source', '==', 'glowpick').get()
  // console.log(snap.docs.length)
  // for (const doc of snap.docs) {
  //   //1. get the products with description and review count is zero 
  //   doc.ref.update({
  //     'ingredients': firestore.FieldValue.delete()
  //   }).then(() => console.log('deleted'))
  //   // console.log(snap.docs.length)
  // }

  // ===========================================================================
  // update user skin en 
  // ===========================================================================
  // var reviews = [];
  // await db.collection('reviews').add(reviwe)

  // for (const doc of snap.docs) {
  //   doc.ref.delete().then(() => console.log('deleted'))
  //   // var enSkinType = translateSkinType(reviewObj.user.skin_type)
  //   // var review = reviewObj;
  //   // review.user.skin_type_en = enSkinType;
  //   // // console.log(review)
  //   // reviews.push(review)
  // }
  // utils.writeJsonToFile('crawled/all_reviews.json', reviews)

  // =============================================================================
  // update masks category products
  // =============================================================================
  // var menu = require('./crawled/masks.json');
  // console.log(menu.length)

  // menu.forEach(async function (obj) {
  //   var snap = await db.collection('products').where('sid', '==', obj.sid).get()
  //   var doc = snap.docs[0]

  //   doc.ref.update({
  //     description: obj.description
  //   }).then(() => console.log('updated'))
  //   // console.log(obj)

  // });




  // //6. send to Hau and Tu
  // const browser = await puppet.launch({
  //   args: ['--no-sandbox', '--disable-setuid-sandbox'],
  //   headless: true,
  //   slowMo: 100,
  //   defaultViewport: null,
  // });
  // const page = await browser.newPage();
  // await page.setDefaultNavigationTimeout(0);

  // var allReviews = [];

  // var products = [];
  // var count = 0
  // var snap = await db.collection('products').where('review_metas.all.review_count', '==', 0).get()
  // console.log(snap.docs.length)

  // for (const doc of snap.docs) {
  //   //get products with translated description
  //   if (doc.data().description !== '') {
  //     //2. get the reviews 

  //     var reviews = await parser.getReviews(page, doc.data().sid)
  //     if (reviews.length > 15) {
  //       reviews = reviews.slice(0, 14)
  //     }
  //     var translatedReviews = [];
  //     for (const review of reviews) {
  //       translatedReview = review;
  //       //3. transalte the reviews 
  //       const [translation] = await translate.translate(review.scontent, 'vi');
  //       translatedReview.content = translation
  //       translatedReview.product = {};
  //       translatedReview.product.sid = doc.data().sid
  //       translatedReviews.push(translatedReview);
  //       console.log(`Translation: ${translation}`);
  //       db
  //         .collection('reviews')
  //         .add(translatedReview).then(() => console.log('added review!'))
  //       //=> I speak English
  //       console.log(translatedReview);
  //     }
  //     console.log(translatedReviews.length)
  //     allReviews.push(...translatedReviews);
  //     // products.push(doc.data())
  //     count++
  //   }
  // }
  // console.log(count)
  // //5. write to local files
  // utils.writeJsonToFile('crawled/reviews.json', allReviews)




})

// function translateSkinTypeToEn(skinType) {
//   switch (skinType) {
//     case 'Da dầu':
//       return 'oily'
//     case 'Da khô':
//       return 'dry'
//     case 'Da hỗn hợp':
//       return 'complex'
//     case 'Da thường':
//       return 'neutral'
//     case 'Nhạy cảm':
//       return 'sensitive'
//     default:
//       break;
//   }
// }

// function translateSkinTypeToVi(skinType) {
//   switch (skinType) {
//     case 'oily':
//       return 'Da dầu'
//     case 'dry':
//       return 'Da khô'
//     case 'complex':
//       return 'Da hỗn hợp'
//     case 'neutral':
//       return 'Da thường'
//     case 'sensitive':
//       return 'Nhạy cảm'
//     default:
//       break;
//   }
// }