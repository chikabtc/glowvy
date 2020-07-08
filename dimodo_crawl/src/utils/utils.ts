// const sleep = (time) => new Promise((resolve) => setTimeout(resolve, time));
// const loadBrowser = async ({ HeadlessMode, PageWidth, PageHeight }) => {
//   try {
//     const args = [
//       "--no-sandbox",
//       "--disable-gpu",
//       `--window-size=${PageWidth},${PageHeight}`,
//     ];
//     const headless = HeadlessMode === "true" ? true : false;
//     const browser = await puppeteer.launch({
//       headless: headless,
//       ignoreHTTPSErrors: true,
//       args: args,
//     });
//     return browser;
//   } catch (e) {
//     console.log(e);
//   }
// };
// const scrollToBottomAndWaitForUrl = async (page, { url }) => {
//   try {
//     await page.evaluate(() => {
//       const elementFooter = document.querySelector("#gp-footer");
//       elementFooter.scrollIntoView(true);
//       elementFooter.scrollIntoView(false);
//     });
//     const result = await page.waitForResponse(
//       (response) => response.url().includes(url) && response.status() === 200
//     );
//     return result.ok();
//   } catch (e) {
//     console.log(e);
//   }
// };
// const scrollToBottom = async (page) => {
//   try {
//     await page.evaluate(() => {
//       const elementFooter = document.querySelector("#gp-footer");
//       elementFooter.scrollIntoView(true);
//       elementFooter.scrollIntoView(false);
//     });
//   } catch (e) {
//     console.log(e);
//   }
// };
// const scrollToTop = async (page) => {
//   try {
//     await page.evaluate(() => {
//       const elementTop = document.querySelector("#gp-default-top");
//       elementTop.scrollIntoView(true);
//       elementTop.scrollIntoView(false);
//     });
//   } catch (e) {
//     console.log(e);
//   }
// };
// const closeBrowser = async (browser) => {
//   try {
//     await browser.close();
//   } catch (e) {
//     console.log(e);
//   }
// };

// module.exports.sleep = sleep;
