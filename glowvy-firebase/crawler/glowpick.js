const path = require('path');
const fs = require('fs');
const directoryPath = path.join(__dirname, 'files');
const parser = require('./parser');
const puppet = require('puppeteer');
const axios = require('axios').default;
const fetch = require('node-fetch');
const { math } = require('mathjs');
const { cachedDataVersionTag } = require('v8');

var token =
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MTI0MjM1NzMsImV4cCI6MTYxMjUwOTk3M30.KyAqFj_GxvncZRQLFN_imVTtU21PU6LnAX7WaZHejfc';

async function getBrandInfo(admin, id) {
  try {
    const db = admin.firestore();
    // console.time(`crawlProductById :${id}`)
    let url = ` https://api-j.glowpick.com/api/ranking/brand/${id}?offset=0&limit=20&order=rank&gender=all&age=all&skinType=all`;
    await axios
      .get(url, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      })
      .then(async (response) => {
        // console.log(response.data.brandInfo)
        var brandInfo = response.data.brandInfo;
        // console.log(glowvyTags)
        var brandName = brandInfo.brandTitle;
        // console.log(brandName)
        let index1 = brandName.indexOf('(');
        let index2 = brandName.indexOf(')');

        if (index1 == -1 || index2 == -1) {
          // console.log(`no change english brand name: ${brandName}`)
        } else {
          brandName = brandName.substring(index1 + 1, index2);
        }
        let brandDoc = await db.collection('brands').doc(brandName).get();
        var brand = {
          id: id,
          sname: brandInfo.brandTitle,
          name: brandName,
          image: brandInfo.brandImg,
          created_at: Date.now(),
          grand_total_count: 0,
        };
        if (!brandDoc.exists) {
          console.log(brand);
          //create brand doc
          await db
            .collection('brands')
            .doc(brandName)
            .set(brand)
            .then(() => console.log('uploaded new brand'));
        }
      });
  } catch (e) {
    console.log(e);
  }
}

async function crawlProductById(admin, id, page) {
  const db = admin.firestore();
  console.time(`crawlProductById :${id}`);
  let url = `https://api-j.glowpick.com/api/product/${id}`;
  await axios
    .get(url, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
    .then(async (response) => {
      let product = response.data.data;
      // //get translated tags from the db?
      // let productsCountDoc = await db.collection('products').doc('product_counter').get();
      // let productId = productsCountDoc.data().count + 1;
      let vnPrice = product.price * 21.5;
      let tags = product.keywords;
      var glowvyTags = [];
      for (const tag of tags) {
        // console.log(tag)
        let keywordSnap = await db
          .collection('product_tags')
          .where('ko_name', '==', tag)
          .get();
        if (keywordSnap.empty) {
          console.log(`no matching keyword :${tag}`);
          var tagJson = {
            ko_name: tag,
          };
          // console.log(tagJson)
          await db
            .collection('product_tags')
            .add(tagJson)
            .then(() => console.log('uploaded tags successfully'));
          break;
        } else {
          // console.log(keywordSnap.docs[0].data().name)
          if (keywordSnap.docs[0].data().name != null) {
            glowvyTags.push(keywordSnap.docs[0].data().name);
          }
        }
      }
      // console.log(glowvyTags)
      var brandName = product.brand.brandTitle;
      // console.log(brandName)
      let index1 = brandName.indexOf('(');
      let index2 = brandName.indexOf(')');

      if (index1 == -1 || index2 == -1) {
        // console.log(`no change english brand name: ${brandName}`)
      } else {
        brandName = brandName.substring(index1 + 1, index2);
      }
      let brandDoc = await db.collection('brands').doc(brandName).get();
      var brand = {
        id: product.brand.idBrand,
        sname: product.brand.brandTitle,
        name: brandName,
        image: product.brand.brandImg,
      };
      const glowpickCategory = product.categoryInfo[0];
      if (!brandDoc.exists) {
        //create brand doc
        await db
          .collection('brands')
          .doc(brandName)
          .set(brand)
          .then(() => console.log('uploaded new brand'));
      } else {
        brand = brandDoc.data();
      }

      let categoryDoc = await db
        .collection('categories')
        .where('id', '==', glowpickCategory.idFirstCategory)
        .get();
      var glowvyCategory = categoryDoc.docs[0].data();
      var firstCateSynonyms = glowvyCategory.synonyms;
      var secondCateSynonyms;
      var thirdCateSynonyms;
      // console.log(glowpickCategory)
      // if (categoryDoc.empty) {
      //     return null
      // }
      // console.log(categoryDoc.docs[0].data())

      let secondCate = glowvyCategory.sub_categories.find(
        (element) => element.id == glowpickCategory.idSecondCategory
      );
      let thirdCategory = secondCate.sub_categories.find(
        (element) => element.id == glowpickCategory.idThirdCategory
      );

      if (secondCate != undefined) {
        thirdCategory = secondCate.sub_categories.find(
          (element) => element.id == glowpickCategory.idThirdCategory
        );
        secondCateSynonyms = secondCate.synonyms;
        // console.log(secondCateSynonyms)
      }

      if (thirdCategory != undefined) {
        thirdCateSynonyms = thirdCategory.synonyms;
        // console.log(thirdCateSynonyms)
      }

      glowvyCategory = {
        first_category_en_name: glowvyCategory.en_name,
        second_category_en_name:
          secondCate != undefined ? secondCate.en_name : null,
        third_category_en_name:
          thirdCategory != undefined ? thirdCategory.en_name : null,
        first_category_id: glowvyCategory.id,
        second_category_id: secondCate != undefined ? secondCate.id : null,
        third_category_id: thirdCategory != undefined ? thirdCategory.id : null,
        first_category_name: glowvyCategory.name,
        second_category_name: secondCate != undefined ? secondCate.name : null,
        third_category_name:
          thirdCategory != undefined ? thirdCategory.name : null,
        first_category_synonyms:
          firstCateSynonyms != undefined ? firstCateSynonyms : [],
        second_category_synonyms:
          secondCateSynonyms != undefined ? secondCateSynonyms : [],
        third_category_synonyms:
          thirdCateSynonyms != undefined ? thirdCateSynonyms : [],
      };
      // console.log(glowvyCategory)
      const glowpickProductURL = `https://www.glowpick.com/product/${id}`;

      await page.goto(glowpickProductURL, {
        waitUntil: 'networkidle0',
      });
      var glowvyIngredients = [];
      console.log(product.idProduct);
      const ingredients = await parser.parseIngredients(page);

      if (ingredients != null) {
        for (const ingredient of ingredients) {
          // console.log(tag)
          let ingredientSnap = await db
            .collection('ingredients')
            .where('name_en', '==', ingredient.name_en)
            .get();
          if (ingredientSnap.empty) {
            console.log(`no matching ingredient ${ingredient.name_en}`);
            //add this ingredients to the product doc regardless
            glowvyIngredients.push(ingredient);
            //add this ingredient to the ingredient collection
            await db
              .collection('missing_ingredients')
              .add(ingredient)
              .then(() => console.log('uploaded ingredient successfully'));
            //update the ingredients purposes on weekly basis using group colleciton query
            break;
          } else {
            glowvyIngredients.push(ingredientSnap.docs[0].data());
          }
        }
      }

      var hazardScore;
      switch (product.ingredientInfo.hazard) {
        case 'low':
          hazardScore = 1;
          break;
        case 'moderate':
          hazardScore = 2;
          break;
        case 'high':
          hazardScore = 3;
          break;
        default:
          hazardScore = 0;
      }

      var productJson = {
        name: '',
        sname: product.productTitle,
        sid: product.idProduct,
        volume: product.volume,
        created_at: Date.now(),
        sprice: product.price,
        official_price: vnPrice,
        thumbnail: `http://storage.googleapis.com/glowvy-b6cf4.appspot.com/product/thumbnail/thumbnail_${product.idProduct}.jpg`,
        description: '',
        sdescription: product.description,
        category: glowvyCategory,
        ingredients: glowvyIngredients,
        brand: brand,
        hazard_score: hazardScore,
        tags: glowvyTags,
        review_metas: {
          all: {
            review_count: 0,
            average_rating: 0,
            ranking_score: 0,
          },
          complex: {
            review_count: 0,
            average_rating: 0,
            ranking_score: 0,
          },
          dry: {
            review_count: 0,
            average_rating: 0,
            ranking_score: 0,
          },
          neutral: {
            review_count: 0,
            average_rating: 0,
            ranking_score: 0,
          },
          oily: {
            review_count: 0,
            average_rating: 0,
            ranking_score: 0,
          },
          sensitive: {
            review_count: 0,
            average_rating: 0,
            ranking_score: 0,
          },
        },
      };

      var toTranslate = {
        sid: productJson.sid,
        name: productJson.name,
        sname: productJson.sname,
        description: productJson.description,
        sdescription: productJson.sdescription,
        category: glowvyCategory,
      };
      if (
        productJson.category.first_category_id == 1 ||
        productJson.category.first_category_id == 9 ||
        productJson.category.first_category_id == 7
      ) {
        var filePath = `./crawled/${productJson.brand.name}.json`;
        //write to big parent cate file + brand name.json
        fs.readFile(filePath, function (err, data) {
          var json = [];
          if (data != null) {
            console.log(' no data');
            json = JSON.parse(data);
          }
          if (!json.some((item) => item.sid === productJson.sid))
            json.push(toTranslate);
          writeJsonToFile(filePath, json);
        });
      }
      await uploadProductToFirestore(admin, productJson, product.productImg);
      console.timeEnd(`crawlProductById :${id}`);
      return productJson;
    });
}

async function uploadProductToFirestore(admin, json, thumbnail) {
  const db = admin.firestore();

  await db
    .collection('products')
    .add(json)
    .then(async function (ref) {
      console.log(`uploaded json to products`);
      var destination = `product/thumbnail/thumbnail_${json.sid}.jpg`;
      await uploadFile(admin, thumbnail, destination);
      for (const ingre of json.ingredients) {
        await ref.collection('ingredients').add(ingre);
      }
    });
}

async function uploadFile(admin, url, destination) {
  // var thumbnailURL;

  const bucket = admin.storage().bucket('glowvy-b6cf4.appspot.com');
  const file = bucket.file(destination);
  const writeStream = file.createWriteStream();

  await fetch(url)
    .then((res) => {
      const contentType = res.headers.get('content-type');
      const writeStream = file.createWriteStream({
        metadata: {
          contentType,
          metadata: {
            myValue: 123,
          },
        },
      });
      console.log('uploaded file successfully');
      res.body.pipe(writeStream);
    })
    .catch((e) =>
      console.log(`
        error uploadFile: $ {
            e
        }
        `)
    );
  // return thumbnailURL;
}

async function uploadThumbs(admin) {
  var token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MDMyOTQwNzksImV4cCI6MTYwMzM4MDQ3OX0.NSYjNXcdR24LhIzWdOt58MMUzteiNb5gsi0R6OOQvC8';
  console.log(token);
  const directoryPath = path.join(__dirname, 'crawled_products');
  console.log(directoryPath);

  fs.readdir(directoryPath, function (err, files) {
    files.forEach(function (file) {
      let fileName = file.substring(0, file.lastIndexOf('.'));
      console.log(fileName);
      //1. make the obj id string
      //2. reupload the objects using
      //3. delete the id property
      var menu = require('./crawled_products/' + file);
      menu.forEach(async function (obj) {
        let url = `
        https: //api-j.glowpick.com/api/product/${obj.sid}`;
        await axios
          .get(url, {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          })
          .then(
            async (response) => {
              let product = response.data.data;
              const bucket = admin.storage().bucket('glowvy-b6cf4.appspot.com');
              const file = bucket.file(
                `product/thumbnail/thumbnail_${obj.sid}.jpg`
              );
              const writeStream = file.createWriteStream();
              var thumbnailURL = product.productImg;

              await fetch(thumbnailURL)
                .then((res) => {
                  const contentType = res.headers.get('content-type');
                  const writeStream = file.createWriteStream({
                    metadata: {
                      contentType,
                    },
                  });
                  console.log('uploaded file successfully');
                  res.body.pipe(writeStream);
                })
                .catch((e) => console.log(`error uploadFile: ${e}`));
            }
            // //get translated tags from the db?
          );
      });
    });
  });
}

async function getIngredients(admin, id, page) {
  try {
    const db = admin.firestore();
    const glowpickProductURL = `https://www.glowpick.com/product/${id}`;
    await page.goto(glowpickProductURL, {
      waitUntil: 'networkidle0',
    });
    var glowvyIngredients = [];
    console.log(id);

    const ingredients = await parser.parseIngredients(page);

    if (ingredients != null) {
      for (const ingredient of ingredients) {
        // console.log(tag)
        let ingredientSnap = await db
          .collection('ingredients')
          .where('name_en', '==', ingredient.name_en)
          .get();
        if (ingredientSnap.empty) {
          console.log(`no matching ingredient ${ingredient.name_en}`);
          //add this ingredients to the product doc regardless
          glowvyIngredients.push(ingredient);
          //add this ingredient to the ingredient collection
          await db
            .collection('missing_ingredients')
            .add(ingredient)
            .then(() =>
              console.log(
                'uploaded missing ingredients ingredient successfully'
              )
            );
          var ingredeientProd = {
            sid: id,
            ing: ingredient,
          };

          await db
            .collection('missing_ingredients_products')
            .add(ingredeientProd)
            .then(() =>
              console.log('added missing ingredients product relationship')
            );
          // update the ingredients purposes on weekly basis using group colleciton query
          break;
        } else {
          glowvyIngredients.push(ingredientSnap.docs[0].data());
        }
      }
    }
    // console.log(glowvyIngredients)
    return glowvyIngredients;
  } catch (error) {
    console.log(error);
  }
}
async function addMissingIngredientsToProducts(puppet, db) {
  const browser = await puppet.launch({
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
    headless: true,
    slowMo: 100,
    defaultViewport: null,
  });
  const page = await browser.newPage();
  await page.setDefaultNavigationTimeout(0);

  var count = 0;

  const snap = await db.collection('products').get();
  console.log(snap.docs.length);
  var cates = [];
  for (const doc of snap.docs) {
    const ingredientSnap = await doc.ref.collection('ingredients').get();
    if (ingredientSnap.docs.length == 0) {
      count++;
      const ingredients = await crawler.getIngredients(
        admin,
        doc.data().sid,
        page
      );
      for (const ing of ingredients) {
        doc.ref
          .collection('ingredients')
          .add(ing)
          .then(() => console.log('added ingredients'));
      }
    }
  }
}

async function crawlProductsByBrand(admin, brandId, offset) {
  const db = admin.firestore();

  console.time(`crawlProductsByBrand :${brandId}`);

  const browser = await puppet.launch({
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
    headless: true,
    slowMo: 100,
    defaultViewport: null,
  });
  const page = await browser.newPage();
  await page.setDefaultNavigationTimeout(0);

  let url = `https://api-j.glowpick.com/api/ranking/brand/${brandId}?offset=${offset}&limit=10000&order=rank&gender=all&age=all&skinType=all`;
  console.log(url);

  await axios
    .get(url, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
    .then(async (response) => {
      let glowpickProducts = response.data.products;
      var products = [];
      for (const product of glowpickProducts) {
        if (product.isDiscontinue != true && product.reviewCnt > 5) {
          const snap = await db
            .collection('products')
            .where('sid', '==', product.idProduct)
            .get();
          if (snap.empty) {
            await crawlProductById(admin, product.idProduct, page);
          } else {
            console.log('duplicated product: not uploading product');
          }
        } else {
          console.log('product is discontinued');
        }
      }
    })
    .catch((e) => console.log(`error crawlProductsByBrand: ${e}`));
  console.timeEnd(`crawlProductsByBrand :${brandId}`);
  return 0;
}

module.exports = {
  crawlProductsByBrand: crawlProductsByBrand,
  crawlProductById: crawlProductById,
  uploadThumbs: uploadThumbs,
  uploadFile: uploadFile,
  getBrandInfo: getBrandInfo,
  getIngredients: getIngredients,
};
