const puppeteer = require('puppeteer');
const parser = require('./parser/glowpick.js')



const sleep = (time) => new Promise((resolve) => setTimeout(resolve, time));
const loadBrowser = async ({
  HeadlessMode,
  PageWidth,
  PageHeight
}) => {
  try {
    const args = ['--no-sandbox', '--disable-gpu', `--window-size=${PageWidth},${PageHeight}`];
    const headless = HeadlessMode === 'true' ? true : false;
    const browser = await puppeteer.launch({
      headless: headless,
      ignoreHTTPSErrors: true,
      args: args
    });
    return browser;
  } catch (e) {
    console.log(e);
  }
};
const scrollToBottomAndWaitForUrl = async (page, {
  url
}) => {
  try {
    await page.evaluate(() => {
      const elementFooter = document.querySelector('#gp-footer');
      elementFooter.scrollIntoView(true);
      elementFooter.scrollIntoView(false);
    });
    const result = await page.waitForResponse((response) => response.url().includes(url) && response.status() === 200);
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

(async () => {
  // initial constants
  const url = 'https://www.glowpick.com/product/124427';
  //
  try {
    const browser = await loadBrowser({
      HeadlessMode: false,
      PageWidth: 1400,
      PageHeight: 2000
    });
    const page = await browser.newPage();
    await page.setViewport({
      width: 1400,
      height: 2000
    });
    await page.goto(url, {
      waitUntil: 'networkidle0',
      timeout: 1000 * 60 // 60 sec
    });
    page.on('response', async (res) => {
      if (res.url().includes('reviews')) {
        await sleep(1000 * 2);
        await scrollToTop(page);
        await sleep(1000 * 2);
        await scrollToBottom(page);
        await sleep(1000 * 10);
      }
    });

    // to start the script
    await sleep(1000 * 2);

    await scrollToBottom(page);
    await sleep(1000 * 5);
    //
    parser.getReviews(page)

    // await closeBrowser(browser);
  } catch (e) {
    console.log(e);
  }
})();