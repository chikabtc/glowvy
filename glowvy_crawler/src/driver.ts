const { Pool, Client } = require("pg");
const sql = require("yesql")("./src/sql/", { type: "pg" });

const pool = new Pool({
  user: "present",
  host: "localhost",
  database: "dimodo",
  password: "your-password",
  port: 5432,
});

const client = new Client({
  user: "present",
  host: "localhost",
  database: "dimodo",
  password: "your-password",
  port: 5432,
});

pool.on("error", (err, client) => {
  console.error("Unexpected error on idle client", err);
  process.exit(-1);
});

//get brand name, sname
async function getCosmeticsProductsWithoutReviews() {
  var products = [] as any;
  try {
    console.log("connected successfully");
    const results = await pool.query(sql.getCosmeticsWithoutReviews());
    results.rows.forEach((element) => {
      products.push(element);
    });
  } catch (e) {
    console.log("something went wrong", e);
  } finally {
    return products;
  }
}

async function getAllCosmetics() {
  var products = [] as any;
  try {
    console.log("connected successfully");
    const results = await pool.query(sql.getAllCosmeticsWithoutIngredients());
    results.rows.forEach((element) => {
      products.push(element);
    });
  } catch (e) {
    console.log("something went wrong", e);
  } finally {
    return products;
  }
}
async function getCosmeticsProductsWithoutSalesPrice() {
  var products = [] as any;
  try {
    console.log("connected successfully");
    const results = await pool.query(sql.getCosmeticsWithoutSalesPrice());
    results.rows.forEach((element) => {
      products.push(element);
    });
  } catch (e) {
    console.log("something went wrong", e);
  } finally {
    return products;
  }
}
async function getLocallyPopularCosmetics() {
  var products = [] as any;
  try {
    console.log("connected successfully");
    const results = await pool.query(sql.getLocallyPopularProduct());
    results.rows.forEach((element) => {
      products.push(element);
    });
  } catch (e) {
    console.log("something went wrong", e);
  } finally {
    return products;
  }
}

async function updateCrawlableState(sid: Number) {
  try {
    const results = await pool.query(
      sql.updateCrawlableState({
        sid: sid,
      })
    );
    console.log("connected successfully");
  } catch (e) {
    console.log("something went wrong", e);
  }
}
async function getCosmeticsWithoutImages() {
  var products = [] as any;
  try {
    console.log("connected successfully");
    const results = await pool.query(sql.getCosmeticsWithoutImages());
    results.rows.forEach((element) => {
      products.push(element);
    });
  } catch (e) {
    console.log("something went wrong", e);
  } finally {
    return products;
  }
}

async function updateCosmeticsMetaInfo(
  salePrice: any,
  productId: Number,
  // reviewCount: String,
  isNaverShopping: boolean
) {
  var products = [] as any;
  try {
    console.log("connected successfully");
    var formattedPrice = parseInt(salePrice.slice(0, -1).replace(",", ""));

    console.log("fomatted:  ", formattedPrice);

    const results = await pool.query(
      sql.updateCosmeticsMetaInfo({
        sale_price: parseInt(salePrice.slice(0, -1).replace(",", "")),
        // review_count: reviewCount.replace(",", ""),
        sid: productId,
      })
    );
  } catch (e) {
    console.log("something went wrong", e);
  } finally {
    return products;
  }
}
async function updateCosmeticsPhotos(images: any, productId: Number) {
  var products = [] as any;
  try {
    console.log(images[0]);
    const results = await pool.query(
      sql.updateCosmeticsPhotos({
        images: images,
        // review_count: reviewCount.replace(",", ""),
        sid: productId,
      })
    );
    console.log("connected successfully");
  } catch (e) {
    console.log("something went wrong", e);
  } finally {
    return products;
  }
}
async function createReview(
  content: any,
  productId: Number,
  rating: Number,
  reviewImages: any,
  userName: String,
  date: any,
  age: String,
  skin: String
) {
  var products = [] as any;
  try {
    console.log("connected successfully");
    const results = await pool.query(
      sql.createReview({
        scontent: content,
        product_id: productId,
        images: reviewImages,
        user_name: userName,
        rating: rating,
        date: date,
        user_age: age,
        skin_type: skin,
      })
    );
  } catch (e) {
    console.log("something went wrong", e);
  } finally {
    return products;
  }
}

async function createIngredient(
  nameEn: any,
  purposenKo: any,
  hazardScore: any,
  productId: any
) {
  var products = [] as any;
  try {
    console.log("connected successfully");
    var score = parseInt(hazardScore);
    var pId = parseInt(productId);
    // console.log(typeof hazardScore);
    console.log(typeof hazardScore);
    console.log(typeof productId);

    const result = await pool.query(
      sql.addIngredient({
        name_en: nameEn,
        purpose_ko: purposenKo,
        hazard_score: score,
        product_id: pId,
      })
    );
    if (result != null) {
      const productExists = await pool.query(
        sql.checkIfIngredientForProductExists({
          name_en: nameEn,
          product_id: pId,
        })
      );
      if (productExists) {
        const results = await pool.query(
          sql.addIngredientToProductTags({
            name_en: nameEn,
            product_id: pId,
          })
        );
      }
    }
  } catch (e) {
    console.log("something went wrong", e);
  } finally {
    return products;
  }
}

async function deleteCosmeticsProduct(productId: Number) {
  try {
    console.log("connected successfully");
    const results = await pool.query(
      sql.deleteCosmeticsProduct({
        sid: productId,
      })
    );
  } catch (e) {
    console.log("something went wrong", e);
  } finally {
  }
}

async () =>
  pool
    .connect()
    .then(() => console.log("connected successfully"))
    .then(() => client.query("SELECT sid FROM cosmetics_products"))
    .then((results) => console.table(results.rows))
    .catch((e) => console.log)
    .finally(() => client.end());

var db = {
  getDB: function () {
    client
      .connect()
      .then(() => console.log("connected successfully"))
      .then(() => client.query("SELECT sid FROM cosmetics_products"))
      .then((results) => console.table(results.rows))
      .catch((e) => console.log)
      .finally(() => client.end());
  },
  getCosmeticsProductsWithoutReviews: getCosmeticsProductsWithoutReviews,
  createReview: createReview,
  updateCrawlableState: updateCrawlableState,
  updateCosmeticsMetaInfo: updateCosmeticsMetaInfo,
  updateCosmeticsPhotos: updateCosmeticsPhotos,
  deleteCosmeticsProduct: deleteCosmeticsProduct,
  getCosmeticsProductsWithoutSalesPrice: getCosmeticsProductsWithoutSalesPrice,
  getCosmeticsWithoutImages: getCosmeticsWithoutImages,
  createIngredient: createIngredient,
  getAllCosmetics: getAllCosmetics,
  getLocallyPopularCosmetics: getLocallyPopularCosmetics,
};

module.exports = db;
