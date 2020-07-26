const puppet = require("puppeteer");
const sleep = (time) => new Promise((resolve) => setTimeout(resolve, time));

// const loadBrowser = async ({ HeadlessMode, PageWidth, PageHeight }) => {
//   try {
//     const args = [
//       "--no-sandbox",
//       "--disable-gpu",
//       `--window-size=${PageWidth},${PageHeight}`,
//     ];
//     const headless = HeadlessMode === "true" ? true : false;
//     const browser = await puppet.launch({
//       headless: headless,
//       ignoreHTTPSErrors: true,
//       args: args,
//     });
//     return browser;
//   } catch (e) {
//     console.log(e);
//   }
// };
const scrollToBottomAndWaitForUrl = async (page, { url }) => {
  try {
    await page.evaluate(() => {
      const elementFooter = document.querySelector("#gp-footer");
      elementFooter.scrollIntoView(true);
      elementFooter.scrollIntoView(false);
    });
    const result = await page.waitForResponse(
      (response) => response.url().includes(url) && response.status() === 200
    );
    return result.ok();
  } catch (e) {
    console.log(e);
  }
};
const scrollToBottom = async (page) => {
  try {
    await page.evaluate(() => {
      const elementFooter = document.querySelector("#gp-footer");
      elementFooter.scrollIntoView(true);
      elementFooter.scrollIntoView(false);
    });
  } catch (e) {
    console.log(e);
  }
};
const scrollToTop = async (page) => {
  try {
    await page.evaluate(() => {
      const elementTop = document.querySelector("#gp-default-top");
      elementTop.scrollIntoView(true);
      elementTop.scrollIntoView(false);
    });
  } catch (e) {
    console.log(e);
  }
};
const closeBrowser = async (browser) => {
  try {
    await browser.close();
  } catch (e) {
    console.log(e);
  }
};

async function getReviews(page, productId) {
  const url = "https://www.glowpick.com/product/" + productId;
  //
  try {
    await page.goto(url, {
      waitUntil: "networkidle0",
      timeout: 1000 * 60, // 60 sec
    });
    await page.waitFor(5000);

    page.on("response", async (res) => {
      if (res.url().includes("reviews")) {
        await sleep(1000 * 2);
        await scrollToTop(page);
        await sleep(1000 * 2);
        await scrollToBottom(page);
        await sleep(1000 * 3);
      }
    });

    // to start the script
    await sleep(1000 * 2);

    await scrollToBottom(page);
    await sleep(1000 * 10);
    //
    return parseReviews(page);

    // await closeBrowser(browser);
  } catch (e) {
    console.log(e);
  }
}

async function parseReviews(page) {
  try {
    const results = await page.$$eval(".review-list-item", (rows) => {
      console.log("lengt: ", rows.length);
      return rows.map((row) => {
        const properties = {};
        const reviewElement = row.querySelector(".review");
        const userElement = row.querySelector(".user-name");

        const dateElement = row.querySelector(".date");

        const ratingElement = row.querySelector(".label > span");

        const ageSkinElement = row.querySelector(".info > span");
        var rating;
        switch (ratingElement.getAttribute("class")) {
          case "icon-sprite rating-grade-icon gpa-best-small":
            rating = 5;
            break;
          case "icon-sprite rating-grade-icon gpa-good-small":
            rating = 4;
            break;
          case "icon-sprite rating-grade-icon gpa-soso-small":
            rating = 3;
            break;
          case "icon-sprite rating-grade-icon gpa-bad-small":
            rating = 2;
            break;
          case "icon-sprite rating-grade-icon gpa-worst-small":
            rating = 1;
            break;
          default:
            break;
        }
        var date = dateElement.innerText.replace(/[^\d]/g, "");
        var age = ageSkinElement.innerText.replace(/[^\d]/g, "");
        var skin;
        if (ageSkinElement.innerText.includes("지성")) {
          skin = "oily";
        } else if (ageSkinElement.innerText.includes("복합성")) {
          skin = "complex";
        } else if (ageSkinElement.innerText.includes("민감성")) {
          skin = "sensitive";
        } else if (ageSkinElement.innerText.includes("건성")) {
          skin = "dry";
        } else if (ageSkinElement.innerText.includes("중성")) {
          skin = "neutral";
        }

        properties["review"] = reviewElement ? reviewElement.innerText : "";
        properties["userName"] = userElement ? userElement.innerText : "";
        properties["date"] = date;
        properties["skin"] = skin;
        properties["age"] = age;
        properties["rating"] = rating;
        // properties["image"] = imageElements ? images : "";
        console.log(properties);

        return properties;
      });
    });
    results.forEach((element) => {
      console.log(element);
    });
    return results;
  } catch (e) {
    console.log(e);
  }
}
async function parseIngredients(page) {
  try {
    await page.waitFor(
      "section.ingredient.contents__product-info__text__section > div > span.contents__link-button > button"
    );

    var ingredientBtn = await page.$(
      `section.ingredient.contents__product-info__text__section > div > span.contents__link-button > button`
    );
    if (ingredientBtn != null) {
      await ingredientBtn.click();

      await page.waitForSelector(".list-ingredient__item");

      const results = await page.$$eval(".list-ingredient__item", (rows) => {
        console.log("lengt: ", rows.length);
        return rows.map((row) => {
          const properties = {};
          const ingredientKo = row.querySelector(
            ".list-ingredient__item__text-korean"
          );
          const ingredientEn = row.querySelector(
            ".list-ingredient__item__text-english"
          );
          const ingredientPurpose = row.querySelector(
            ".list-ingredient__item__text-purpose"
          );
          const ingrdientScore = row.querySelector(
            "div.list-ingredient__item__row.list-ingredient__item__icon-wrapper > span"
          );
          var hazardScore;
          switch (ingrdientScore.getAttribute("class")) {
            case "icon icon-sprite list-ingredient__item__icon label-safety-green-large":
              hazardScore = 1;
              break;
            case "icon icon-sprite list-ingredient__item__icon label-safety-orange-large":
              hazardScore = 2;
              break;
            case "icon icon-sprite list-ingredient__item__icon label-safety-red-large":
              hazardScore = 3;
              break;
            default:
              hazardScore = 0;
              break;
          }
          // console.log(hazard);

          properties["name_en"] = ingredientEn ? ingredientEn.innerText : "";
          properties["purpose_ko"] = ingredientPurpose
            ? ingredientPurpose.innerText
            : "";
          properties["hazard_score"] = hazardScore;
          // properties["image"] = imageElements ? images : "";
          console.log(properties);

          return properties;
        });
      });
      results.forEach((element) => {
        console.log(element);
      });
      return results;
    }
  } catch (e) {
    console.log(e);
  }
}

module.exports.getReviews = getReviews;
module.exports.parseIngredients = parseIngredients;
