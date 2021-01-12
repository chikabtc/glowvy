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
})