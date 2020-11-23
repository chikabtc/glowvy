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
  // ===========================================================================
  // add missing product field to the algolia
  // ===========================================================================
  // cosmeticsIndex.delete();

  var snap = await db.collection('products').where('category.first_category_id', '==', 8).get()
  console.log(snap.docs.length)
  for (const doc of snap.docs) {
    try {
      var product = doc.data();
      const algoliaRecrod = {
        name: product.name,
        sprice: product.sprice,
        sid: product.sid,
        objectID: product.sid,
        description: product.description,
        volume: product.volume,
        // desc_images: product.desc_images,
        hazard_level: product.hazard_score,
        // 'sdescription': product.sdescription,
        brand: product.brand,
        category: product.category,
        tags: product.tags,
        review_metas: product.review_metas,
        thumbnail: product.thumbnail,
      };
      cosmeticsIndex.saveObject(algoliaRecrod).then(() => console.log('uu'));
    } catch (error) {
      console.log(error)

    }


  }



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




})()

function translateSkinTypeToEn(skinType) {
  switch (skinType) {
    case 'Da dầu':
      return 'oily'
    case 'Da khô':
      return 'dry'
    case 'Da hỗn hợp':
      return 'complex'
    case 'Da thường':
      return 'neutral'
    case 'Nhạy cảm':
      return 'sensitive'
    default:
      break;
  }
}

function translateSkinTypeToVi(skinType) {
  switch (skinType) {
    case 'oily':
      return 'Da dầu'
    case 'dry':
      return 'Da khô'
    case 'complex':
      return 'Da hỗn hợp'
    case 'neutral':
      return 'Da thường'
    case 'sensitive':
      return 'Nhạy cảm'
    default:
      break;
  }
}