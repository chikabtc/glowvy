const fs = require("fs");
const pupet = require("puppeteer");

const postgres = require("./driver.ts");
const naverShoppingCrawler = require("./naver_shopping/crawler.ts");
const glowPickCrawler = require("./glowpick/glowpick");

(async () => {
  var productsWithoutReviews = await postgres.getCosmeticsWithoutImages();

  const browser = await pupet.launch({
    args: ["--no-sandbox", "--disable-setuid-sandbox"],
    headless: false,
    slowMo: 100,
    defaultViewport: null,
  });
  var reviews: any;
  var url =
    "https://search.shopping.naver.com/detail/detail.nhn?nvMid=21886489917&query=%EB%A7%A4%EB%93%9C%20%EB%A7%A4%ED%8A%B8%20%EB%A6%BD&NaPm=ct%3Dkcd0ao2o%7Cci%3Da2e42f1742ba7ae22229be9040ac0f13333ce27e%7Ctr%3Dslsl%7Csn%3D95694%7Chk%3Ded4cf28ba5a6b4492782de05177421eb05a6689b";
  const page = await browser.newPage();
  // console.log(productsWithoutReviews.length);
  var reviews = await naverShoppingCrawler.extractReviews(page, url);

  if (reviews != "undefined") {
    // console.log("images length", reviews.l);
    reviews?.forEach(
      (element) => postgres.updateCosmeticsPhotos(element?.images, 85963)
      // postgres.createReviews(
      //   element["review"],
      //   productsWithoutReviews[i]?.sid,
      //   element["rating"],
      //   element["review_images"],
      //   element["userName"],
      //   element["date"],
      //   element["age"],
      //   element["skin"]
      // ),
      // {}
    );
  }
  // for (let i = 0; i < productsWithoutReviews.length; i++) {
  //   var product = productsWithoutReviews[i];
  //   var info = await naverShoppingCrawler.getProductMetaInfo(
  //     page,
  //     product["sname"] + " " + product["volume"]
  //   );
  //   // if (info != "undefined") {
  //   //   await postgres.updateCosmeticsMetaInfo(
  //   //     info?.sale_price,
  //   //     product?.sid,
  //   //     info?.is_naver_shopping
  //   //   );
  //   // }
  //   var reviews = await naverShoppingCrawler.extractReviews(page, info["url"]);
  //   // console.log(reviews?[0].review_images)
  //   // var reviews = await glowPickCrawler.getReviews(
  //   //   page,
  //   //   productsWithoutReviews[i]?.sid
  //   // );

  //   // if (reviews != "undefined") {
  //   //   // console.log("images length", reviews.l);
  //   //   reviews?.forEach(
  //   //     (element) =>
  //   //       postgres.updateCosmeticsPhotos(
  //   //         element?.images,
  //   //         productsWithoutReviews[i]?.sid
  //   //       )
  //   //     // postgres.createReviews(
  //   //     //   element["review"],
  //   //     //   productsWithoutReviews[i]?.sid,
  //   //     //   element["rating"],
  //   //     //   element["review_images"],
  //   //     //   element["userName"],
  //   //     //   element["date"],
  //   //     //   element["age"],
  //   //     //   element["skin"]
  //   //     // ),
  //   //     // {}
  //   //   );
  //   // }
  // }
})();
