const puppeteer = require("puppeteer");
const util = require("../utils/utils.ts");

//1. sale_price
//2. review count
async function getProductMetaInfo(page: any, url: string) {
  await page.goto(url, { waitUntil: "networkidle0" });
  var results;
  // var lists = await page.$$(".basicList_item__2XT81");
  // console.log("list count: ", lists.length);
  // lists.map

  try {
    results = await page.$$eval(".basicList_item__2XT81", (rows) => {
      return rows.map((row) => {
        console.log("row", row);
        const properties = {};
        const priceElement = row.querySelector(".price_num__2WUXn");
        const titleElement = row.querySelector(".basicList_link__1MaTN");
        const reviewCountElement = row.querySelector(".basicList_num__1yXM9");
        const urlElement = row.querySelector(".thumbnail_thumb__3Agq6");
        const priceCompareListElement = row.querySelector(
          ".basicList_compare__3AjuT"
        );
        const internationalShipping = row.querySelector(
          ".basicList_inner__eY_mq .basicList_info_area__17Xyo .basicList_title__3P9Q7 .ad_label__Ve7Bp"
        );

        // const ratingElement = row.querySelector(".curr_avg");
        // const imageElements = row.querySelectorAll(".img_box img");
        //   const etcInfoElement = row.querySelector(".avg_area");
        properties["sale_price"] = priceElement ? priceElement.innerText : "";
        properties["title"] = titleElement ? titleElement.innerText : "";
        properties["is_naver_shopping"] =
          priceCompareListElement == null ? false : true;
        properties["url"] = urlElement ? urlElement.getAttribute("href") : "";

        properties["review_count"] = reviewCountElement
          ? reviewCountElement.innerText
          : "";

        console.log("international shipping btn:", internationalShipping);
        properties["international_shipping"] =
          internationalShipping == null ? false : true;
        return properties;
      });
    });
  } catch (error) {
    console.log(error);
  }
  console.log(results[0]);

  for (let i = 0; i < 2; i++) {
    if (typeof results[i] != "undefined") {
      console.log("using the first item");
      if (results[i]?.international_shipping || results[i]?.review_count == 0) {
        return null;
      } else {
        return results[i];
      }
    }
  }
}

//need to find the best product to crawl the reviews from
//skip ads
//check if it's a smart store or not ?? how to check?
async function extractReviews(page: any) {
  var reviews: object[] = [];

  //loop based on the number of buttons and break when it reaches 5
  const pageButtons = await page.$$(`#_review_paging a`);
  // console.log("page button count: ", pageButtons.length);
  var togglBtn = await page.$(
    `#_review_sort > div.filter_box > div.check > span > a`
  );
  if (togglBtn == null) {
    return reviews;
  }
  await togglBtn?.click();

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
        if (element?.review_images.length != 0) {
          console.log(element?.review_images);
          element?.review_images.forEach((image) => {
            reviews.push(image);
          });
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

async function extractSmartStorePhotos(page: any) {
  //wait for the review tab
  var images: String[] = [];
  await page.waitForSelector(
    "div.detail_tab_floatable > ul > li:nth-child(2) > a"
  );
  //click the review tab to load the reviews
  await page.evaluate(() => {
    let element: HTMLElement = document.querySelector(
      "div.detail_tab_floatable > ul > li:nth-child(2) > a"
    );
    element.click();
  });
  //reviwe count
  await page.waitForSelector(
    "#area_review_list > div.header_review._review_list_header > strong > span"
  );
  const element = await page.$(
    "#area_review_list > div.header_review._review_list_header > strong > span"
  );
  const count = await page.evaluate((element) => element.textContent, element);
  console.log("review count: ", count);
  if (count > 10) {
    //if there is more than one review page
    await page.waitForSelector("#review_list_area");
    await page.waitForSelector("#area_review_photo");
    var reviewPhotos = await page.$$("#area_review_photo > ul > li");
    console.log("review photos count: ", reviewPhotos.length);

    var showMoreBtn = await page.$(
      `#area_review_photo > ul > li:nth-child(${reviewPhotos.length}) > a`
    );
    await showMoreBtn.click();
    // var images;
    await page.waitForSelector("#review_list_area > li.item_photo._listItems");
    images = await page.$$eval(
      "#review_list_area > li.item_photo._listItems",
      (rows) => {
        console.log("rows count: ", rows.length);
        return rows.map((row) => {
          try {
            const image = row.querySelector("a > img").getAttribute("src");
            console.log("imageElement: ", image);
            return image;
          } catch (e) {
            console.log(e);
          }
        });
      }
    );
    return images;
  }
  return images;
}

async function extractSmartStoreReviews(page: any) {
  var reviews: object[] = [];
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
  const count = await page.evaluate((element) => element.textContent, element);
  console.log("review count: ", count);
  if (count > 25) {
    //if there is more than one ereview page
    await page.waitForSelector("#review_list_area");
    const images = await page.$$("#review_list_area");
    console.log("images count: ", images.length);

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
          if (element?.review_images.length != 0) {
            console.log(element?.review_images);
            element?.review_images.forEach((image) => {
              reviews.push(image);
            });
          }
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
        if (element?.review_images.length != 0) {
          console.log(element?.review_images);
          element?.review_images.forEach((image) => {
            reviews.push(image);
          });
        }
      });
    } catch (e) {
      console.log(e);
    }
    return reviews;
  }
}
module.exports.extractReviews = extractReviews;
module.exports.extractSmartStorePhotos = extractSmartStorePhotos;
module.exports.extractSmartStoreReviews = extractSmartStoreReviews;
module.exports.getProductMetaInfo = getProductMetaInfo;
