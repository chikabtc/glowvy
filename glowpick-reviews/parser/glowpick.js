const puppeteer = require("puppeteer");

async function getReviews(page) {
    try {
        const results = await page.$$eval(".review-list-item", (rows) => {
            console.log("lengt: ", rows.length);
            return rows.map((row) => {
                const properties = {};
                const reviewElement = row.querySelector(".review");
                const userElement = row.querySelector(
                    ".user-name"
                );

                const dateElement = row.querySelector(
                    ".date"
                );

                const ratingElement = row.querySelector(
                    ".label > span"
                );

                const ageSkinElement = row.querySelector(
                    ".info > span"
                );
                var rating;
                switch (ratingElement.getAttribute("class")) {
                    case "icon-sprite rating-grade-icon gpa-best-small":
                        rating = 5
                        break;
                    case "icon-sprite rating-grade-icon gpa-good-small":
                        rating = 4
                        break;
                    case "icon-sprite rating-grade-icon gpa-soso-small":
                        rating = 3
                        break;
                    case "icon-sprite rating-grade-icon gpa-bad-small":
                        rating = 2
                        break;
                    case "icon-sprite rating-grade-icon gpa-worst-small":
                        rating = 1
                        break;
                    default:
                        break;
                }
                properties["review"] = reviewElement ? reviewElement.innerText : "";
                properties["userName"] = userElement ? userElement.innerText : "";
                properties["date"] = dateElement ? dateElement.innerText : "";
                properties["ageSkin"] = ageSkinElement ? ageSkinElement.innerText : "";
                properties["rating"] = rating;
                // properties["image"] = imageElements ? images : "";
                console.log(properties);

                return properties;
            });
        });
        results.forEach((element) => {
            console.log(element);
        });
        // const btns = await page.$$(
        //     "#area_review_list > div.paginate._review_list_page a"
        // );
        // await btns[i].click();
    } catch (e) {
        console.log(e);
    }
}


module.exports.getReviews = getReviews;