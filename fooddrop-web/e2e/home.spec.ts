import { expect, test } from "@playwright/test";

test("home page has Food Drop title, favicon and manifest", async ({ page, request }) => {
  await page.goto("/");
  await expect(page).toHaveTitle("Food Drop");
  await expect(page.locator('link[rel="icon"]')).toHaveAttribute("href", /favicon\.ico/);

  const manifest = await request.get("/manifest.webmanifest");
  expect(manifest.ok()).toBe(true);
  expect((await manifest.json()).name).toBe("Food Drop");
});
