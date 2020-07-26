const puppeteer = require("puppeteer");
const util = require("../utils/utils.ts");

//1. sale_price
//2. review count
async function getProductMetaInfo(page: any, url: string) {
  await page.goto(url, { waitUntil: "networkidle0" });

  try {
    const results = await page.$$eval(".list_basis", (rows) => {
      return rows.map((row) => {
        const properties = {};
        const priceElement = row.querySelector(".price_num__2WUXn");
        const titleElement = row.querySelector(".basicList_link__1MaTN");
        const reviewCountElement = row.querySelector(".basicList_num__1yXM9");
        const urlElement = row.querySelector(".thumbnail_thumb__3Agq6");
        const priceCompareListElement = row.querySelector(
          ".basicList_compare__3AjuT"
        );
        // const ratingElement = row.querySelector(".curr_avg");
        // const imageElements = row.querySelectorAll(".img_box img");
        //   const etcInfoElement = row.querySelector(".avg_area");
        properties["sale_price"] = priceElement ? priceElement.innerText : "";
        properties["title"] = titleElement ? titleElement.innerText : "";
        properties["is_naver_shopping"] =
          priceCompareListElement == null ? false : true;
        properties["productTitle"] = titleElement ? titleElement.innerText : "";
        properties["url"] = urlElement ? urlElement.getAttribute("href") : "";

        properties["review_count"] = reviewCountElement
          ? reviewCountElement.innerText
          : "";

        return properties;
      });
    });
    console.log(results[0]);

    if (typeof results[0] != "undefined") {
      return results[0];
    } else if (results[1] != "undefined") {
      return results[1];
    } else {
      return null;
    }
  } catch (error) {
    console.log(error);
  }
}

//need to find the best product to crawl the reviews from
//skip ads
//check if it's a smart store or not ?? how to check?
async function extractReviews(page: any, productDetailPageURL) {
  var reviews: object[] = [];

  await page.goto(productDetailPageURL, { waitUntil: "networkidle0" });

  //loop based on the number of buttons and break when it reaches 5
  const pageButtons = await page.$$(`#_review_paging a`);
  var togglBtn = await page.$(
    `#_review_sort > div.filter_box > div.check > span > a`
  );
  await togglBtn.click();

  for (let i = 0; i < pageButtons.length; i++) {
    if (i > 5) {
      break;
    }
    await new Promise((resolve) => setTimeout(resolve, 1500));
    await page.evaluate("window.scrollTo(0,document.body.scrollHeight)");
    await new Promise((resolve) => setTimeout(resolve, 3000));

    await page.evaluate("window.scrollTo(0,0)");
    await new Promise((resolve) => setTimeout(resolve, 1500));

    try {
      const results = await page.$$eval(".thumb_nail", (rows) => {
        return rows.map((row) => {
          // await row.click();
          // await new Promise((resolve) => setTimeout(resolve, 1500));

          const properties = {};
          const reviewElement = row.querySelector(".atc");
          const userElement = row.querySelector(
            ".avg_area > span > span:nth-child(2)"
          );
          const dateElement = row.querySelector(
            ".avg_area > span > span:nth-child(3)"
          );
          const ratingElement = row.querySelector(".curr_avg");
          //   const etcInfoElement = row.querySelector(".avg_area");
          //
          var images: string[] = [];
          const date = Date.now();
          let currentDate = null;

          const imageElements = row.querySelectorAll(".img_box img");
          console.log("imageElements", imageElements);

          imageElements.forEach((element) => {
            var image = element.getAttribute("src");
            if (!image.includes("placeholder")) {
              images.push(image);
              console.log(image);
            }
            console.log(image);
          });

          properties["review"] = reviewElement ? reviewElement.innerText : "";
          properties["userName"] = userElement ? userElement.innerText : "";
          properties["date"] = dateElement ? dateElement.innerText : "";
          properties["rating"] = ratingElement ? ratingElement.innerText : "";
          properties["review_images"] = imageElements ? images : "";

          return properties;
        });
      });
      results.forEach((element) => {
        if (element.images.length != 0) {
          reviews.push(element);
          console.log(element);
        }
      });

      const pageButtons = await page.$$(`#_review_paging a`);

      await pageButtons[i].click();
    } catch (e) {
      console.log(`error: `, e);
    }
  }
  console.log("reviews length: ", reviews.length);

  return reviews;
}

async function extractSmartStoreReviews(page: any, productDetailPageURL) {
  var reviews: object[] = [];
  await page.goto(productDetailPageURL, { waitUntil: "networkidle0" });

  var redirectedURL = await page.url();
  console.log(redirectedURL);
  if (redirectedURL.includes("smartstore")) {
    await page.waitForSelector(
      "div.detail_tab_floatable > ul > li:nth-child(2) > a"
    );
    await page.evaluate(() => {
      let element: HTMLElement = document.querySelector(
        "div.detail_tab_floatable > ul > li:nth-child(2) > a"
      );
      element.click();
    });

    await page.waitForSelector(
      "#area_review_list > div.header_review._review_list_header > strong > span"
    );
    const element = await page.$(
      "#area_review_list > div.header_review._review_list_header > strong > span"
    );
    const count = await page.evaluate(
      (element) => element.textContent,
      element
    );
    console.log("review count: ", count);

    if (count > 25) {
      //if there is more than one review page
      await page.waitForSelector(
        "#area_review_list > div.paginate._review_list_page a"
      );
      const pageButtons = await page.$$(
        "#area_review_list > div.paginate._review_list_page a"
      );

      console.log("pageButtons: ", pageButtons.length);

      for (let i = 0; i < pageButtons.length; i++) {
        if (i > 5) {
          break;
        }

        try {
          const results = await page.$$eval(".area_user_review", (rows) => {
            console.log("lengt: ", rows.length);
            return rows.map((row) => {
              const properties = {};
              const reviewElement = row.querySelector(".area_text > p");
              const userElement = row.querySelector(
                ".area_status_user > span:nth-child(1)"
              );
              const dateElement = row.querySelector(
                ".area_status_user > span:nth-child(2)"
              );
              const ratingElement = row.querySelector(
                ".area_star_small .number_grade"
              );
              const imageElements = row.querySelectorAll(
                ".area_full_image .review_image > img"
              );
              var images: string[] = [];

              imageElements.forEach((element) => {
                images.push(element.getAttribute("src"));
              });

              properties["review"] = reviewElement
                ? reviewElement.innerText
                : "";
              properties["userName"] = userElement ? userElement.innerText : "";
              properties["date"] = dateElement ? dateElement.innerText : "";
              properties["rating"] = ratingElement
                ? ratingElement.innerText
                : "";
              properties["review_images"] = imageElements ? images : "";
              console.log(properties);

              return properties;
            });
          });
          results.forEach((element) => {
            console.log(element);
          });
          const btns = await page.$$(
            "#area_review_list > div.paginate._review_list_page a"
          );
          await btns[i].click();
        } catch (e) {
          console.log(e);
        }
      }
      return reviews;
    } else {
      try {
        const results = await page.$$eval(".area_user_review", (rows) => {
          console.log("lengt: ", rows.length);
          return rows.map((row) => {
            const properties = {};
            const reviewElement = row.querySelector(".area_text > p");
            const userElement = row.querySelector(
              ".area_status_user > span:nth-child(1)"
            );
            const dateElement = row.querySelector(
              ".area_status_user > span:nth-child(2)"
            );
            const ratingElement = row.querySelector(
              ".area_star_small .number_grade"
            );
            const imageElements = row.querySelectorAll(
              ".area_full_image .review_image > img"
            );
            var images: string[] = [];

            imageElements.forEach((element) => {
              images.push(element.getAttribute("src"));
            });

            properties["review"] = reviewElement ? reviewElement.innerText : "";
            properties["userName"] = userElement ? userElement.innerText : "";
            properties["date"] = dateElement ? dateElement.innerText : "";
            properties["rating"] = ratingElement ? ratingElement.innerText : "";
            properties["review_images"] = imageElements ? images : "";
            console.log(properties);

            return properties;
          });
        });
        results.forEach((element) => {
          console.log(element);
        });
      } catch (e) {
        console.log(e);
      }
      return reviews;
    }
  }
}
module.exports.extractReviews = extractReviews;
module.exports.extractSmartStoreReviews = extractSmartStoreReviews;
module.exports.getProductMetaInfo = getProductMetaInfo;
