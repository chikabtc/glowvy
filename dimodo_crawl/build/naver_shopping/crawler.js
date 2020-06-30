var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var puppeteer = require("puppeteer");
//1. sale_price
//2. review count
function getProductMetaInfo(page, productTitle) {
    return __awaiter(this, void 0, void 0, function () {
        var searchURL, results;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    searchURL = "https://search.shopping.naver.com/search/all?frm=NVSHATC&pagingIndex=1&pagingSize=40&productSet=total&query=" +
                        productTitle +
                        "&sort=rel&timestamp=&viewType=list";
                    return [4 /*yield*/, page.goto(searchURL, { waitUntil: "networkidle0" })];
                case 1:
                    _a.sent();
                    return [4 /*yield*/, page.$$eval(".list_basis", function (rows) {
                            return rows.map(function (row) {
                                var properties = {};
                                var priceElement = row.querySelector(".price_num__2WUXn");
                                var titleElement = row.querySelector(".basicList_link__1MaTN");
                                var reviewCountElement = row.querySelector(".basicList_num__1yXM9");
                                var urlElement = row.querySelector(".thumbnail_thumb__3Agq6");
                                var priceCompareListElement = row.querySelector(".basicList_compare__3AjuT");
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
                                console.log(properties);
                                return properties;
                            });
                        })];
                case 2:
                    results = _a.sent();
                    if (typeof results[0] === "undefined") {
                        console.log("no review");
                        return [2 /*return*/, null];
                    }
                    if (results[0]["review_count"] < 10) {
                        return [2 /*return*/, results[1]];
                    }
                    else {
                        return [2 /*return*/, results[0]];
                    }
                    return [2 /*return*/];
            }
        });
    });
}
//need to find the best product to crawl the reviews from
//skip ads
//check if it's a smart store or not ?? how to check?
function extractReviews(page, productDetailPageURL) {
    return __awaiter(this, void 0, void 0, function () {
        var reviews, i, results, pageButtons, e_1;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    reviews = [];
                    return [4 /*yield*/, page.goto(productDetailPageURL, { waitUntil: "networkidle0" })];
                case 1:
                    _a.sent();
                    i = 0;
                    _a.label = 2;
                case 2:
                    if (!(i < 5)) return [3 /*break*/, 9];
                    _a.label = 3;
                case 3:
                    _a.trys.push([3, 7, , 8]);
                    return [4 /*yield*/, page.$$eval(".thumb_nail", function (rows) {
                            return rows.map(function (row) {
                                var properties = {};
                                var reviewElement = row.querySelector(".atc");
                                var userElement = row.querySelector(".avg_area > span > span:nth-child(2)");
                                var dateElement = row.querySelector(".avg_area > span > span:nth-child(3)");
                                var ratingElement = row.querySelector(".curr_avg");
                                var imageElements = row.querySelectorAll(".img_box img");
                                //   const etcInfoElement = row.querySelector(".avg_area");
                                //
                                var images = [];
                                imageElements.forEach(function (element) {
                                    images.push(element.getAttribute("src"));
                                });
                                properties["review"] = reviewElement ? reviewElement.innerText : "";
                                properties["userName"] = userElement ? userElement.innerText : "";
                                properties["date"] = dateElement ? dateElement.innerText : "";
                                properties["rating"] = ratingElement ? ratingElement.innerText : "";
                                properties["image"] = imageElements ? images : "";
                                console.log(properties);
                                return properties;
                            });
                        })];
                case 4:
                    results = _a.sent();
                    results.forEach(function (element) {
                        reviews.push(element);
                    });
                    return [4 /*yield*/, page.$$("#_review_paging a")];
                case 5:
                    pageButtons = _a.sent();
                    return [4 /*yield*/, pageButtons[i].click()];
                case 6:
                    _a.sent();
                    return [3 /*break*/, 8];
                case 7:
                    e_1 = _a.sent();
                    console.log("error: ", e_1);
                    return [3 /*break*/, 8];
                case 8:
                    i++;
                    return [3 /*break*/, 2];
                case 9:
                    console.log("reviews length: ", reviews.length);
                    return [2 /*return*/, reviews];
            }
        });
    });
}
function extractSmartStoreReviews(page, productDetailPageURL) {
    return __awaiter(this, void 0, void 0, function () {
        var reviews;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    reviews = [];
                    return [4 /*yield*/, page.goto(productDetailPageURL, { waitUntil: "networkidle0" })];
                case 1:
                    _a.sent();
                    return [4 /*yield*/, page.waitForSelector("#wrap > div._easy_purchaseV2.module_detail_simplebuy > div > div.detail_tab_floatable > ul > li:nth-child(2) > a")];
                case 2:
                    _a.sent();
                    // await page.waitFor(2000);
                    //loop based on the rows and break when it reaches 5
                    return [4 /*yield*/, page.evaluate(function () {
                            var element = document.querySelector("#wrap > div._easy_purchaseV2.module_detail_simplebuy > div > div.detail_tab_floatable > ul > li:nth-child(2) > a");
                            element.click();
                        })];
                case 3:
                    // await page.waitFor(2000);
                    //loop based on the rows and break when it reaches 5
                    _a.sent();
                    // await reviewButton.click();
                    setTimeout(function () {
                        return __awaiter(this, void 0, void 0, function () {
                            var pageButtons, results, e_2;
                            return __generator(this, function (_a) {
                                switch (_a.label) {
                                    case 0: return [4 /*yield*/, page.$$("#area_review_list > div.paginate._review_list_page a")];
                                    case 1:
                                        pageButtons = _a.sent();
                                        _a.label = 2;
                                    case 2:
                                        _a.trys.push([2, 4, , 5]);
                                        return [4 /*yield*/, page.$$eval(".area_user_review", function (rows) {
                                                console.log("lengt: ", rows.length);
                                                return rows.map(function (row) {
                                                    var properties = {};
                                                    var reviewElement = row.querySelector(".area_text > p");
                                                    var userElement = row.querySelector(".area_status_user > .span:nth-child(1)");
                                                    var dateElement = row.querySelector(".area_status_user > .span:nth-child(2)");
                                                    var ratingElement = row.querySelector(".area_star_small > .number_grade");
                                                    var imageElements = row.querySelectorAll(".area_full_image > .review_image");
                                                    var images = [];
                                                    imageElements.forEach(function (element) {
                                                        images.push(element.getAttribute("src"));
                                                    });
                                                    properties["review"] = reviewElement ? reviewElement.innerText : "";
                                                    properties["userName"] = userElement ? userElement.innerText : "";
                                                    properties["date"] = dateElement ? dateElement.innerText : "";
                                                    properties["rating"] = ratingElement ? ratingElement.innerText : "";
                                                    properties["image"] = imageElements ? images : "";
                                                    console.log(properties);
                                                    return properties;
                                                });
                                            })];
                                    case 3:
                                        results = _a.sent();
                                        return [3 /*break*/, 5];
                                    case 4:
                                        e_2 = _a.sent();
                                        console.log(e_2);
                                        return [3 /*break*/, 5];
                                    case 5: return [2 /*return*/];
                                }
                            });
                        });
                    }, 1000);
                    // console.log("reviews length: ", reviews.length);
                    return [2 /*return*/, reviews];
            }
        });
    });
}
module.exports.extractReviews = extractReviews;
module.exports.extractSmartStoreReviews = extractSmartStoreReviews;
module.exports.getProductMetaInfo = getProductMetaInfo;
