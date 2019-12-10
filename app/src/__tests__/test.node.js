const puppeteer = require('puppeteer');

test('App loads', async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('http://localhost:3000');

  const content = await page.content();
  expect(content).toContain("Let's Get Started");

  await browser.close();
});
