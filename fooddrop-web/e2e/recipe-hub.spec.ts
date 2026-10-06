import { expect, test } from "@playwright/test";

// Needs the backend (Postgres + seed data) behind the /backend proxy; skipped when it is not running.
test.beforeAll(async ({ request }) => {
  const health = await request.get("/backend/health").catch(() => null);
  test.skip(!health?.ok(), "backend is not reachable at API_INTERNAL_URL");
});

test("sign up, create, filter, edit and delete a recipe", async ({ page }) => {
  const unique = Date.now();
  const title = `E2E Egg Rice ${unique}`;

  // Sign up
  await page.goto("/login");
  await page.getByRole("button", { name: "Tạo tài khoản" }).click();
  await page.getByLabel("Tên hiển thị").fill("E2E Cook");
  await page.getByLabel("Email").fill(`e2e-${unique}@example.test`);
  await page.getByLabel("Mật khẩu", { exact: true }).fill(`pw-${unique}-e2e`);
  await page.getByRole("button", { name: "Tạo tài khoản" }).click();
  await expect(page).toHaveURL(/\/recipes$/);
  await expect(page.getByText("Chưa có công thức nào")).toBeVisible();

  // Create: ingredient autocomplete (diacritic-insensitive), a step with timer, a tag
  await page.getByRole("link", { name: "Thêm công thức" }).click();
  await page.getByLabel("Tiêu đề").fill(title);
  await page.getByRole("button", { name: "Thêm nguyên liệu" }).click();
  await page.getByRole("combobox", { name: "Tên nguyên liệu 1" }).fill("trung");
  await page.getByRole("listbox").getByRole("option").first().click();
  await page.getByLabel("Số lượng").fill("2");
  await page.getByRole("textbox", { name: "Bước 1" }).fill("Fry the egg <b>not bold</b>");
  await page.getByLabel("Hẹn giờ (phút, không bắt buộc)").fill("3");
  await page.getByRole("button", { name: "Món Việt" }).click();
  await page.getByRole("button", { name: "Lưu công thức" }).click();

  // Detail: user text is rendered literally, not as HTML
  await expect(page.getByRole("heading", { level: 1, name: title })).toBeVisible();
  await expect(page.getByText("Fry the egg <b>not bold</b>")).toBeVisible();
  await expect(page.getByText("Hẹn giờ: 3 phút")).toBeVisible();

  // List + URL-synced filters
  await page.goto("/recipes");
  await expect(page.getByRole("link", { name: new RegExp(title) })).toBeVisible();
  await page.getByRole("button", { name: "Món Nhật" }).click();
  await expect(page).toHaveURL(/tags=\d+/);
  await expect(page.getByText("Không có công thức nào phù hợp với bộ lọc.")).toBeVisible();
  await page.getByRole("button", { name: "Xóa bộ lọc" }).click();
  await expect(page).toHaveURL(/\/recipes$/);
  await page.getByRole("button", { name: "Món Việt" }).click();
  await expect(page).toHaveURL(/tags=\d+/);
  await page.reload(); // filters survive a reload because they live in the URL
  await expect(page.getByRole("button", { name: "Món Việt" })).toHaveAttribute("aria-pressed", "true");
  await expect(page.getByRole("link", { name: new RegExp(title) })).toBeVisible();

  // Edit
  await page.getByRole("link", { name: new RegExp(title) }).click();
  await page.getByRole("link", { name: "Sửa" }).click();
  await expect(page.getByLabel("Tiêu đề")).toHaveValue(title);
  await page.getByLabel("Tiêu đề").fill(`${title} v2`);
  await page.getByRole("button", { name: "Lưu công thức" }).click();
  await expect(page.getByRole("heading", { level: 1, name: `${title} v2` })).toBeVisible();

  // Delete
  page.once("dialog", (dialog) => dialog.accept());
  await page.getByRole("button", { name: "Xóa" }).click();
  await expect(page).toHaveURL(/\/recipes$/);
  await expect(page.getByText("Chưa có công thức nào")).toBeVisible();

  // Sign out
  await page.getByRole("button", { name: "Đăng xuất" }).click();
  await expect(page).toHaveURL(/\/login/);
  await page.goto("/recipes");
  await expect(page).toHaveURL(/\/login\?next=%2Frecipes$/);
});
