const fs = require("fs");
const pupet = require("puppeteer");

const postgres = require("./driver.ts");
const naverShoppingCrawler = require("./naver_shopping/crawler.ts");

(async () => {
  //get the reviwes
  //1. retrieve the products without reviews
  var productsWithoutReviews = await postgres.getCosmeticsProductsWithoutReviews();

  const browser = await pupet.launch({
    args: ["--no-sandbox", "--disable-setuid-sandbox"],
    headless: false,
    slowMo: 100,
    defaultViewport: null,
  }); //     var reviews: any;

  var reviews: any;

  const page = await browser.newPage();

  // // const page = await browser.newPage();
  // console.log("products count: ", productsWithoutReviews.length);
  // //2. loop through the products
  // var reviews = await naverShoppingCrawler.extractSmartStoreReviews(
  //   page,
  //   "https://smartstore.naver.com/k-beauties/products/3802947361?NaPm=ct%3Dkbxou368%7Cci%3Db79dea405251b35d7f0f1b9def980dc81e4233ef%7Ctr%3Dslsl%7Csn%3D699456%7Chk%3D6d07c1eb735e9ab1439724339ce20bff4495679d"
  // );
  // if (reviews != "undefined") {
  //   reviews?.forEach(
  //     (element) =>
  //       postgres.createReviews(
  //         element["review"],
  //         114984,
  //         element["rating"],
  //         element["image"],
  //         element["userName"],
  //         element["date"]
  //       ),
  //     {}
  //   );
  // }

  for (let i = 0; i < productsWithoutReviews.length; i++) {
    try {
      var product = productsWithoutReviews[i];

      var query = product["sname"] + " " + product["volume"];
      //3. get thep product meta info
      var metaInfo = await naverShoppingCrawler.getProductMetaInfo(page, query);
      if (
        typeof metaInfo === "undefined" ||
        metaInfo === null ||
        metaInfo.sale_price === ""
      ) {
        //delete the fucking damn thing
        console.log("no search result");
      } else {
        //       // console.log("url: " + metaInfo["url"] + " productID: " + product["sid"]);
        //       // console.log("price of product: ", metaInfo["sale_price"]);
        //       // var isSuccess = postgres.updateCosmeticsMetaInfo(
        //       //   metaInfo["sale_price"],
        //       //   product["sid"],
        //       //   metaInfo["review_count"],
        //       //   metaInfo["is_naver_shopping"]
        //       // );
        //       // console.log("URL: " + metaInfo["url"] + "productID: " + product["sid"]);
        var reviews: any;
        if (metaInfo["is_naver_shopping"] === true) {
          console.log("scraping naver shopping compare reviews");

          reviews = await naverShoppingCrawler.extractReviews(
            page,
            metaInfo["url"]
          );
          if (reviews != "undefined") {
            reviews?.forEach(
              (element) =>
                postgres.createReviews(
                  element["review"],
                  product["sid"],
                  element["rating"],
                  element["image"],
                  element["userName"],
                  element["date"]
                ),
              {}
            );
          }
          //if it's a naver's smart store link
        } else {
          // console.log("scraping smartstore reviews");
          // reviews = await naverShoppingCrawler.extractSmartStoreReviews(
          //   page,
          //   metaInfo["url"]
          // );
          // if (reviews != "undefined") {
          //   reviews?.forEach(
          //     (element) =>
          //       postgres.createReviews(
          //         element["review"],
          //         product["sid"],
          //         element["rating"],
          //         element["image"],
          //         element["userName"],
          //         element["date"]
          //       ),
          //     {}
          //   );
          // }
        }
      }
    } catch (e) {
      console.log(e);
    }
  }
})();
