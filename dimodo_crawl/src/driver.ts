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
      // console.log(
      //   element["ko_name"].replace("(", "").replace(")", "") +
      //     " " +
      //     element["sname"] +
      //     " " +
      //     element["volume"]
      // );
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
  reviewCount: String,
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
        review_count: reviewCount.replace(",", ""),
        sid: productId,
        is_naver_shopping: isNaverShopping,
      })
    );
  } catch (e) {
    console.log("something went wrong", e);
  } finally {
    return products;
  }
}
async function createReviews(
  content: any,
  productId: Number,
  rating: Number,
  reviewImages: any,
  date: any,
  userName: String
) {
  var products = [] as any;
  try {
    console.log("connected successfully");
    const results = await pool.query(
      sql.createReviews({
        scontent: content,
        product_id: productId,
        images: reviewImages,
        user_name: userName,
        rating: rating,
        date: date,
      })
    );
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
  createReviews: createReviews,
  updateCosmeticsMetaInfo: updateCosmeticsMetaInfo,
  deleteCosmeticsProduct: deleteCosmeticsProduct,
};

module.exports = db;
