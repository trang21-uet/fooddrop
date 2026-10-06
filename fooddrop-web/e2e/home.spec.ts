import { expect, test } from "@playwright/test";

test("signed-out visitors land on the sign-in page with favicon and manifest", async ({ page, request }) => {
  await page.goto("/");
  await expect(page).toHaveURL(/\/login\?next=%2F$/);
  await expect(page).toHaveTitle("Đăng nhập · Food Drop");
  await expect(page.locator('link[rel="icon"]')).toHaveAttribute("href", /favicon\.ico/);

  const manifest = await request.get("/manifest.webmanifest");
  expect(manifest.ok()).toBe(true);
  expect((await manifest.json()).name).toBe("Food Drop");
});

test("protected routes redirect to login and keep the destination", async ({ page }) => {
  await page.goto("/recipes/new");
  await expect(page).toHaveURL(/\/login\?next=%2Frecipes%2Fnew$/);
});
