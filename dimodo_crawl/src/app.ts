const fs = require("fs");
const pupet = require("puppeteer");

const postgres = require("./driver.ts");
const naverShoppingCrawler = require("./naver_shopping/crawler.ts");
const glowPickCrawler = require("./glowpick/glowpick");
const sleepTill = (time) => new Promise((resolve) => setTimeout(resolve, time));

(async () => {
  var productsWithoutReviews = await postgres.getCosmeticsProductsWithoutReviews();

  const browser = await pupet.launch({
    args: ["--no-sandbox", "--disable-setuid-sandbox"],
    headless: false,
    slowMo: 100,
    defaultViewport: null,
  });
  var ingredients: any;
  const page = await browser.newPage();
  console.log(productsWithoutReviews.length);
  // var storeurl =
  //   "https://smartstore.naver.com/laka/products/4794122305?NaPm=ct%3Dkcu5k8xc%7Cci%3D23cf5fa05b6c46dad77e9f74801843b0dcacd84d%7Ctr%3Dslsl%7Csn%3D708006%7Chk%3Dad51345c1092da1ac9b5317969f99aae8fd89946#revw";
  // var reviews = await naverShoppingCrawler.extractSmartStoreReviews(
  //   page,
  //   storeurl
  // );
  // console.log(reviews);
  // if (reviews != "undefined") {
  //   // console.log("images length", reviews.l);
  //   reviews?.forEach((element) =>
  //     postgres.updateCosmeticsPhotos(
  //       productsWithoutReviews[i]?.sid,
  //       element["review_images"],
  //       false
  //     )
  //   );
  // }

  // ===========================================================================
  // Glowpick reviews and ingredients
  // ===========================================================================
  for (let i = 0; i < productsWithoutReviews.length; i++) {
    var product = productsWithoutReviews[i];
    var sid = product?.sid;
    var url = "https://www.glowpick.com/product/" + product["sid"];
    console.log("productSid: " + url);
    await page.goto(url, { waitUntil: "networkidle0" });
    var ingredients = await glowPickCrawler.parseIngredients(page);
    if (ingredients != null) {
      for (let i = 0; i < ingredients.length; i++) {
        const ingredient = ingredients[i];
        console.log(ingredient);
        await postgres.createIngredient(
          ingredient?.name_en,
          ingredient?.purpose_ko,
          ingredient?.hazard_score,
          sid
        );
      }
    }
    var reviews = await glowPickCrawler.getReviews(page, sid);
    if (reviews != null) {
      for (let i = 0; i < reviews.length; i++) {
        const review = reviews[i];
        console.log(review);
        await postgres.createReview(
          review?.review,
          sid,
          review?.rating,
          null,
          review?.userName,
          review?.date,
          review?.age,
          review?.skin
        );
      }
    }

    // var url =
    //   "https://search.shopping.naver.com/search/all?query=" +
    //   product["sname"] +
    //   " " +
    //   product["volume"];
    // var productMetaInfo = await naverShoppingCrawler.getProductMetaInfo(
    //   page,
    //   url
    // );
    // console.log("URL: ", productMetaInfo?.url);
    // sleepTill(2);

    //wait for the url to load
    // =========================================================================
    // Save Meta Data - prices
    // =========================================================================
    // if (productMetaInfo != null) {
    //   postgres.updateCosmeticsMetaInfo(
    //     productMetaInfo["sale_price"],
    //     product?.sid,
    //     false
    //   );
    // }

    // if (productMetaInfo != null) {
    //   if (productMetaInfo?.url.includes("smartstore")) {
    //     console.log("this is smartstore");
    //     var reviews = await naverShoppingCrawler.extractSmartStoreReviews(
    //       page,
    //       page.url()
    //     );
    //     if (reviews != "undefined") {
    //       // console.log("images length", reviews.l);
    //       reviews?.forEach((element) =>
    //         postgres.updateCosmeticsPhotos(
    //           product?.sid,
    //           element["review_images"],
    //           false
    //         )
    //       );
    //     }
    //   } else if (productMetaInfo?.url.includes("shopping.naver.com")) {
    //     console.log("this is naver comparison");

    //     var reviews = await naverShoppingCrawler.extractReviews(
    //       page,
    //       page.url()
    //     );
    //     if (reviews != "undefined") {
    //       // console.log("images length", reviews.l);
    //       reviews?.forEach((element) =>
    //         postgres.updateCosmeticsPhotos(
    //           product?.sid,
    //           element["review_images"],
    //           false
    //         )
    //       );
    //     }
    //   }
    // }
  }
})();
