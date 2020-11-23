const puppet = require('puppeteer');

const sleep = (time) => new Promise((resolve) => setTimeout(resolve, time));
const path = require('path');
const axios = require('axios').default;

const scrollToBottomAndWaitForUrl = async (page, {
    url
}) => {
    try {
        await page.evaluate(() => {
            const elementFooter = document.querySelector('#gp-footer');
            elementFooter.scrollIntoView(true);
            elementFooter.scrollIntoView(false);
        });
        const result = await page.waitForResponse(
            (response) => response.url().includes(url) && response.status() === 200,
        );
        return result.ok();
    } catch (e) {
        console.log(e);
    }
};
const scrollToBottom = async (page) => {
    try {
        await page.evaluate(() => {
            const elementFooter = document.querySelector('#gp-footer');
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
            const elementTop = document.querySelector('#gp-default-top');
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
    const url = `https://www.glowpick.com/product/${productId}?order=like_desc`;
    console.log(url)
    //
    try {
        await page.goto(url, {
            waitUntil: 'networkidle0',
            timeout: 1000 * 60, // 60 sec
        });
        await page.waitFor(5000);

        page.on('response', async (res) => {
            if (res.url().includes('reviews')) {
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
        return parseReviews(page, productId);
    } catch (e) {
        console.log(e);
    }
}

async function parseReviews(page, sid) {

    try {
        const results = await page.$$eval('.review-list-item', (rows) => {
            console.log('review length: ', rows.length);
            return rows.map((row) => {

                const properties = {};
                const reviewElement = row.querySelector('.review');
                const userElement = row.querySelector('.user-name');

                const dateElement = row.querySelector('.date');

                const ratingElement = row.querySelector('.label > span');

                const ageSkinElement = row.querySelector('.info > span');
                let rating;
                switch (ratingElement.getAttribute('class')) {
                    case 'icon-sprite rating-grade-icon gpa-best-small':
                        rating = 5;
                        break;
                    case 'icon-sprite rating-grade-icon gpa-good-small':
                        rating = 4;
                        break;
                    case 'icon-sprite rating-grade-icon gpa-soso-small':
                        rating = 3;
                        break;
                    case 'icon-sprite rating-grade-icon gpa-bad-small':
                        rating = 2;
                        break;
                    case 'icon-sprite rating-grade-icon gpa-worst-small':
                        rating = 1;
                        break;
                    default:
                        break;
                }
                const date = dateElement.innerText.replace(/[^\d]/g, '');
                const age = ageSkinElement.innerText.replace(/[^\d]/g, '');
                let skin;
                let skinEn;
                if (ageSkinElement.innerText.includes('지성')) {
                    skin = 'Da dầu';
                    skinEn = 'oily'
                } else if (ageSkinElement.innerText.includes('복합성')) {
                    skin = 'Da hỗn hợp';
                    skinEn = 'complex';
                } else if (ageSkinElement.innerText.includes('민감성')) {
                    skin = 'Nhạy cảm';
                    skinEn = 'sensitive';
                } else if (ageSkinElement.innerText.includes('건성')) {
                    skin = 'Da khô';
                    skinEn = 'dry';
                } else if (ageSkinElement.innerText.includes('중성')) {
                    skin = 'Da thường';
                    skinEn = 'neutral';
                }
                properties.scontent = reviewElement ? reviewElement.innerText : '';
                properties.user = {};
                properties.user.display_name = userElement ? userElement.innerText : '';
                properties.user.skin_type = skin;
                properties.user.age = age;
                properties.user.skin_type_en = skinEn;
                properties.rating = rating;
                properties.source = 'glowpick';
                properties.created_at = Date.now();
                // console.log(properties);
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
        // await page.waitFor(
        //     'section.ingredient.contents__product-info__text__section > div > span.contents__link-button > button',
        // );
        const ingredientBtn = await page.$(
            'section.ingredient.contents__product-info__text__section > div > span.contents__link-button > button',
        );
        if (ingredientBtn != null) {
            await ingredientBtn.click();

            page.waitForSelector('.list-ingredient__item');

            const results = await page.$$eval('.list-ingredient__item', (rows) => {
                console.log('lengt: ', rows.length);
                return rows.map((row) => {
                    const properties = {};
                    const ingredientKo = row.querySelector(
                        '.list-ingredient__item__text-korean',
                    );
                    const ingredientEn = row.querySelector(
                        '.list-ingredient__item__text-english',
                    );
                    const ingredientPurpose = row.querySelector(
                        '.list-ingredient__item__text-purpose',
                    );
                    const ingrdientScore = row.querySelector(
                        'div.list-ingredient__item__row.list-ingredient__item__icon-wrapper > span',
                    );
                    let hazardScore;
                    switch (ingrdientScore.getAttribute('class')) {
                        case 'icon icon-sprite list-ingredient__item__icon label-safety-green-large':
                            hazardScore = 1;
                            break;
                        case 'icon icon-sprite list-ingredient__item__icon label-safety-orange-large':
                            hazardScore = 2;
                            break;
                        case 'icon icon-sprite list-ingredient__item__icon label-safety-red-large':
                            hazardScore = 3;
                            break;
                        default:
                            hazardScore = 0;
                            break;
                    }
                    // console.log(hazard);

                    properties.name_en = ingredientEn ? ingredientEn.innerText : '';
                    properties.purpose_ko = ingredientPurpose ?
                        ingredientPurpose.innerText :
                        '';
                    properties.hazard_score = hazardScore;
                    // properties['image'] = imageElements ? images : '';
                    // console.log(properties);

                    return properties;
                });
            });

            return results;
        }
    } catch (e) {
        console.log(e);
    }
}



module.exports.getReviews = getReviews;
module.exports.parseIngredients = parseIngredients;