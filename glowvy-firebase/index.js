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
const {
  allowedNodeEnvironmentFlags
} = require("process");
const {
  util
} = require("prettier");




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
  const browser = await puppet.launch({
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
    headless: true,
    slowMo: 100,
    defaultViewport: null,
  });
  const page = await browser.newPage();
  await page.setDefaultNavigationTimeout(0);

  var count = 0
  // ===========================================================================
  // collect purpose from db
  // ===========================================================================
  var all_purposes = [];
  const allIngredientsSnap = await db.collection('ingredients').get();
  for (const doc of allIngredientsSnap.docs) {
    var purposes = doc.data().purposes
    if (purposes != null) {
      for (i = 0; i < purposes.length; i++) {
        var purpose = purposes[i]
        var purpose_ko = doc.data().purpose_ko.split(', ')[i]
        if (!all_purposes.some(e => e.purpose_machine_translated === purpose)) {
          var purposeJson = {
            'purpose_machine_translated': purpose,
            'name': '',
            'purpose_ko': purpose_ko
          }
          all_purposes.push(purposeJson)
        }
      }

    }

  }
  console.log(all_purposes)
  console.log(all_purposes.length)
  utils.writeJsonToFile(all_purposes, './crawled/purposes.json');


  // var allIngredients = [];
  // const allIngredientsSnap = await db.collection('ingredients').get();
  // for (const doc of allIngredientsSnap.docs) {
  //   allIngredients.push(doc.data())
  // }
  // console.log(allIngredients.length)

  //1. loop products
  // const snap = await db.collection('ingredients').get()
  // // const snap = await db.collection('ingredients').get()
  // console.log(snap.docs.length)
  // var ingredients = [];

  // for (const doc of snap.docs) {
  //   // await db.collection('ingredients').add(doc.data()).then(() => console.log('uploaded'))
  //   // const ingredient = doc.data()
  //   // const translatedPurposesString = await translate.translate(ingredient.purpose_ko, 'vi');
  //   var ingredient = doc.data()
  //   ingredient.name = ""
  //   delete ingredient.name_vi
  //   ingredients.push(ingredient);

  //   // // console.log(translatedPurposesString[0])
  //   // const purposeList = translatedPurposesString[0].split(",");
  //   // doc.ref.update({
  //   //   'purposes': purposeList
  //   // }).then(() => console.log('updated'))
  //   // console.log(purposeList)
  //   // console.log(purposeList)
  // }
  // utils.writeJsonToFile(ingredients, './crawled/ingredients.json');


  // const snap = await db.collection('ingredients').get()
  // // const snap = await db.collection('ingredients').get()
  // console.log(snap.docs.length)
  // var purposes = [];

  // for (const doc of snap.docs) {
  //   await db.collection('ingredients').add(doc.data()).then(() => console.log('uploaded'))
  //   // const ingredient = doc.data()
  //   // const translatedPurposesString = await translate.translate(ingredient.purpose_ko, 'vi');
  //   ingredients.push(doc.data());
  //   // // console.log(translatedPurposesString[0])
  //   // const purposeList = translatedPurposesString[0].split(",");
  //   // doc.ref.update({
  //   //   'purposes': purposeList
  //   // }).then(() => console.log('updated'))
  //   // console.log(purposeList)
  //   // console.log(purposeList)
  // }
  // utils.writeJsonToFile(ingredients, './crawled/ingredients');

  // var missingIngredients = [];
  // var cates = [];

  // //2. get ingredient docs from subcollection
  // for (const doc of snap.docs) {
  //   console.time('update ingredients')
  //   const ingredientSnap = await doc.ref.collection('ingredients').get()
  //   var glowvyIngredients = []
  //   //3. create a list of ingredients
  //   for (const ingredientDoc of ingredientSnap.docs) {
  //     glowvyIngredients.push(ingredientDoc.data())
  //   }
  //   //4. crwal ingredients from glowpick
  //   const ingredients = await crawler.getIngredients(admin, doc.data().sid, page)
  //   //5. compare the subcollection count to the glowpick ingredients count
  //   // if (ingredients.length != glowvyIngredients) {
  //   //   for (const ing of ingredients) {
  //   //     if (!glowvyIngredients.includes(ing)) {
  //   //       console.log('ingredient does not exist on product subcollection but exist on the glowpick')

  //   //       //6. if the ingredient is not available and ingredients is unavailable on the databaset, then add it to the missing_ingredient collection
  //   //       if (!allIngredients.some(glowvyIngredient => glowvyIngredient.name_en === ing.name_en)) {
  //   //         console.log('ingredient does not exist on product subcollection but exist on the glowpick')
  //   //         await db.collection('missing_ingredients').add(ing).then(() => console.log('added missing ingredients'))
  //   //         //7. create a file that contains sid and missing ingredient 
  //   //         var ingredeientProd = {
  //   //           'sid': doc.data().sid,
  //   //           'ing': ing
  //   //         }

  //   //         //7. add the relation to the firestore collection and when the missing ingredients are all translated, we will upload those to the products

  //   //         // await db.collection('missing_ingredients_products').add(ingredeientProd).then(() => console.log('added missing ingredients product relationship'))
  //   //       }

  //   //     } else {}
  //   //   }
  //   // }

  //   console.timeEnd('update ingredients')
  // }









})().catch((err) => console.log(err))