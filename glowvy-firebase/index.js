var admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');
var serviceAccount = require('./service_key.json');
// const directoryPath = path.join(__dirname, "/utils/files/categories.json");
// var json = require(`${__dirname}/utils/files/categories.json`);
const axios = require('axios').default;
const fetch = require('node-fetch');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://glowvy-b6cf4.firebaseio.com',
});
const puppet = require('puppeteer');
var token =
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MDU1ODUwNjksImV4cCI6MTYwNTY3MTQ2OX0.3y6wDRJEEJ34fqV9Wk-B70-7ugofRL5hR9jDhNgB0rE';
const projectId = 'dimodo - 1585384547888';
const { Translate } = require('@google-cloud/translate').v2;
const translate = new Translate({
  projectId,
});
const algolia = require('algoliasearch');

const client = algolia.default(
  '50G6MO803G',
  'ab5eb7ec7552bb7865f3819a2b08f462'
);
const cosmeticsIndex = client.initIndex('cosmetics'); //

const db = admin.firestore();
const crawler = require('./crawler/glowpick');
const allNames = require('./crawled/all_name.json');
const directoryPath = path.join(__dirname, 'crawled');

const { firestore } = admin;

const utils = require('./utils/utils');
const parser = require('./crawler/parser');
const glowpick = require('./crawler/glowpick');
const { BADNAME } = require('dns');
const { prod, string } = require('mathjs');
const { bohrRadiusDependencies } = require('mathjs');
const { get } = require('http');
const { allowedNodeEnvironmentFlags } = require('process');
const { util } = require('prettier');

function writeJsonToFile(path, json) {
  fs.writeFile(path, JSON.stringify(json, null, 4), (err) => {
    if (err) {
      console.error(err);
      return;
    }
    console.log('File has been created');
  });
}

(async () => {
  db.settings({
    ignoreUndefinedProperties: true,
  });
  // const browser = await puppet.launch({
  //   args: ['--no-sandbox', '--disable-setuid-sandbox'],
  //   headless: true,
  //   slowMo: 100,
  //   defaultViewport: null,
  // });
  // const page = await browser.newPage();
  // await page.setDefaultNavigationTimeout(0);

  // var count = 0
  // var all = [];
  // var menu = require("./crawled/all.json")
  // for (let i = 0; i < menu.length; i++) {
  //   var obj = menu[i]
  //   var name = await translate.translate(obj.sname, 'vi').catch(function (err) {
  //     console.log(err)
  //   })
  //   // console.log(name[0])
  //   var description = await translate.translate(obj.sdescription, 'vi').catch(function (err) {
  //     console.log(err)
  //   })
  //   var product = obj
  //   product.name = name[0];
  //   product.description = description[0];
  //   all.push(product)
  // }
  // console.log(all.length)
  // utils.writeJsonToFile(all, 'crawled/all_trans.json')

  // await fs.readdir(directoryPath, function (err, files) {
  //   if (err) {
  //     return console.log("Unable to scan directory: " + err);
  //   }
  //   //
  //   for (let i = 0; i < files.length; i++) {
  //     var file = files[i]
  //     // let fileName = file.substring(0, file.lastIndexOf("."));
  //     // // console.log(fileName)
  //     // var name = fileName + '.json'
  //     // console.log(allNames[i])
  //     //1. make the obj id string
  //     //2. reupload the objects using
  //     //3. delete the id property
  //     if (allNames[i] !== undefined) {
  //       var menu = require("./crawled/" + allNames[i]);
  //       console.log(menu.length)
  //       // var products = file
  //       // console.log(file)
  //       menu.forEach(function (obj) {
  //         all.push(obj)
  //       });

  //     }

  //   }
  //   utils.writeJsonToFile(all, 'crawled/all.json')
  // })

  // ===========================================================================
  // collect brands
  // ===========================================================================
  //
  // var brands = require('./crawled/brands.json')
  const snap = await db.collection('reviews').get();
  console.log(snap.docs.length);
  var count = 0;
  // utils.updateProductBrandInfo(db)

  // for (const doc of snap.docs) {
  //   var tags = doc.data().tags
  //   var tagString = []
  //   if (doc.data().created_at > 1612326420422) {
  //     for (const tag of tags) {
  //       tagString.push(tag.name)
  //     }
  //     doc.ref.update({
  //       'tags': tagString
  //     }).then(() => console.log('updated'))
  //   }

  // for (const tag of tags) {

  // }

  //1. check if the brand is created today
  //2. get the products ranked by the review count
  //3.
  // utils.writeJsonToFile(brands, './crawled/brands.json')
  // }
  // const snap = await db.collection('brands').get()
  // console.log(snap.docs.length)
  // // var count = 0
  // // utils.updateProductBrandInfo(db)
  // for (const doc of snap.docs) {
  //   await crawler.crawlProductsByBrand(admin, doc.data().id, 0)
  //   //1. check if the brand is created today
  //   //2. get the products ranked by the review count
  //   //3.
  //   // utils.writeJsonToFile(brands, './crawled/brands.json')
  // }

  // console.log(count)
  // // console.log(brandIds.length)
})().catch((err) => console.log(err));
