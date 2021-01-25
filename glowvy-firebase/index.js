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

(async () => {
  db.settings({
    ignoreUndefinedProperties: true
  })
  var newprods = require("./crawled/fix-products2.json");
  // console.log(newprods.length)

  // var count = 0

  // const snap = await db.collection('products').get()
  for (const prod of newprods) {
    db.collection('products').add(prod).then(() => console.log('added prod'))

    //   //1. check if the product is duplicate 
    //   if (await utils.isDuplicate(db, doc.data().sid)) {
    //     count++
    //     db.collection('products').where('sid', '==', doc.data().sid).get()
    //       .then(function (querySnapshot) {
    //         // Once we get the results, begin a batch
    //         var batch = db.batch();

    //         querySnapshot.forEach(function (doc) {
    //           // For each doc, add a delete operation to the batch
    //           batch.delete(doc.ref);
    //         });

    //         // Commit the batch
    //         return batch.commit();
    //       }).then(function () {
    //         console.log('deleted duplicates')
    //         // Delete completed!
    //         // ...
    //       });
  }
  //2. if duplicate, then delete both duplicate doc 


  // await utils.updateBrandProductCount(db, doc.data(), 1)
  // await utils.updateCategoryProductCount(db, doc.data(), 1)
  // }




  // await utils.clearBrandTotalCount(db)
  // await utils.clearCategoriesTotalCount(db)

  // const snap = await db.collection('products').get()
  // for (const doc of snap.docs) {
  //   await utils.updateBrandProductCount(db, doc.data(), 1)
  //   await utils.updateCategoryProductCount(db, doc.data(), 1)
  // }




})().catch((err) => console.log(err))