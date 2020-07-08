// const pupet = require("puppeteer");

// (async () => {
//     var productsWithoutReviews = await postgres.getCosmeticsWithoutImages();

//     const browser = await pupet.launch({
//         args: ["--no-sandbox", "--disable-setuid-sandbox"],
//         headless: false,
//         slowMo: 100,
//         defaultViewport: null,
//     });
//     var url =
//         "https://search.shopping.naver.com/detail/detail.nhn?nvMid=22566828697&query=굳세라%20수퍼%20세라마이드%20크림%20인%20세럼&NaPm=ct%3Dkcbxqkmg%7Cci%3D7d50a74f1ea018c9e56227cd910b3279e6a71a7a%7Ctr%3Dslsl%7Csn%3D95694%7Chk%3D19ac2954fe769241ea132d05f50ad39a3e6be45d";
//     const page = await browser.newPage();
//     // console.log(productsWithoutReviews.length);
//     var reviews = [];

//     await page.goto(url, {
//         waitUntil: "networkidle0"
//     });

//     //loop based on the number of buttons and break when it reaches 5
//     const pageButtons = await page.$$(`#_review_paging a`);
//     var togglBtn = await page.$(
//         `#_review_sort > div.filter_box > div.check > span > a`
//     );
//     await togglBtn.click();

//     for (let i = 0; i < pageButtons.length; i++) {
//         if (i > 5) {
//             break;
//         }
//         await new Promise((resolve) => setTimeout(resolve, 1500));
//         await page.evaluate("window.scrollTo(0,document.body.scrollHeight)");
//         await new Promise((resolve) => setTimeout(resolve, 3000));

//         await page.evaluate("window.scrollTo(0,0)");
//         await new Promise((resolve) => setTimeout(resolve, 1500));

//         try {
//             const results = await page.$$eval(".thumb_nail", (rows) => {
//                 return rows.map((row) => {
//                     // await row.click();
//                     // await new Promise((resolve) => setTimeout(resolve, 1500));

//                     const properties = {};
//                     const reviewElement = row.querySelector(".atc");
//                     const userElement = row.querySelector(
//                         ".avg_area > span > span:nth-child(2)"
//                     );
//                     const dateElement = row.querySelector(
//                         ".avg_area > span > span:nth-child(3)"
//                     );
//                     const ratingElement = row.querySelector(".curr_avg");
//                     //   const etcInfoElement = row.querySelector(".avg_area");
//                     //
//                     var images = [];
//                     const date = Date.now();
//                     let currentDate = null;

//                     const imageElements = row.querySelectorAll(".img_box img");
//                     console.log("imageElements", imageElements);

//                     imageElements.forEach((element) => {
//                         var image = element.getAttribute("src");
//                         if (!image.includes("placeholder")) {
//                             images.push(image);
//                             console.log(image);
//                         }
//                         console.log(image);
//                     });

//                     properties["review"] = reviewElement ? reviewElement.innerText : "";
//                     properties["userName"] = userElement ? userElement.innerText : "";
//                     properties["date"] = dateElement ? dateElement.innerText : "";
//                     properties["rating"] = ratingElement ? ratingElement.innerText : "";
//                     properties["images"] = imageElements ? images : "";

//                     return properties;
//                 });
//             });
//             // results.forEach((element) => {
//             //   if (element.images.length != 0) {
//             //     reviews.push(element);
//             //     console.log(element);
//             //   }
//             // });

//             const pageButtons = await page.$$(`#_review_paging a`);

//             await pageButtons[i].click();
//         } catch (e) {
//             console.log(`error: `, e);
//         }
//     }
//     console.log("reviews length: ", reviews.length);

//     return reviews;
// })();