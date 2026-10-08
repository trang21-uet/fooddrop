import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { ApiError } from "@/lib/api/api-error";
import { clearParseCooldown } from "./parse-cooldown";
import type { ParseJob } from "./parser-types";
import { RecipeImportView } from "./recipe-import-view";

const startUrlImport = vi.fn();
const startImageImport = vi.fn();
const get = vi.fn();

vi.mock("next/navigation", () => ({
  useRouter: () => ({ push: vi.fn(), replace: vi.fn(), refresh: vi.fn(), back: vi.fn() }),
}));
vi.mock("./start-import", () => ({
  startUrlImport: (...args: unknown[]) => startUrlImport(...args),
  startImageImport: (...args: unknown[]) => startImageImport(...args),
}));
vi.mock("@/lib/api/api-client", () => ({
  apiClient: {
    GET: (...args: unknown[]) => get(...args),
    POST: vi.fn(),
    PUT: vi.fn(),
  },
}));

const job = (overrides: Partial<ParseJob>): ParseJob => ({
  id: "job-1",
  status: "queued",
  sourceType: "url",
  errorCode: null,
  result: null,
  createdAt: "2026-10-07T00:00:00.000Z",
  cooldownSeconds: 60,
  ...overrides,
});
const respond = (data: ParseJob) => ({ data, response: new Response(null, { status: 200 }) });

function renderView() {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(
    <QueryClientProvider client={client}>
      <RecipeImportView />
    </QueryClientProvider>,
  );
}

const submitUrl = (url: string) => {
  fireEvent.change(screen.getByLabelText("Liên kết công thức"), { target: { value: url } });
  fireEvent.click(screen.getByRole("button", { name: "Đọc công thức" }));
};

describe("RecipeImportView", () => {
  beforeEach(() => {
    clearParseCooldown();
    startUrlImport.mockReset();
    startImageImport.mockReset();
    get.mockReset();
    // Catalog and tag lookups made by the recipe form once a draft is shown.
    get.mockImplementation(async (path: string) =>
      path === "/parser/jobs/{id}" ? respond(job({})) : { data: [], response: new Response(null, { status: 200 }) },
    );
  });

  it("keeps the submit button disabled until a link is entered", () => {
    renderView();
    expect(screen.getByRole("button", { name: "Đọc công thức" })).toBeDisabled();
  });

  it("starts a URL import and shows progress while the job runs", async () => {
    startUrlImport.mockResolvedValue(job({ cooldownSeconds: 60 }));
    renderView();
    submitUrl("https://blog.example/pho");

    expect(await screen.findByRole("status")).toHaveTextContent("Đang đọc công thức");
    expect(startUrlImport).toHaveBeenCalledWith("https://blog.example/pho");
  });

  it("shows the editable draft in the recipe form when the job succeeds", async () => {
    startUrlImport.mockResolvedValue(job({ cooldownSeconds: 60 }));
    get.mockImplementation(async (path: string) =>
      path === "/parser/jobs/{id}"
        ? respond(
            job({
              status: "succeeded",
              result: {
                source: "json-ld",
                title: "Phở bò",
                description: null,
                imageUrl: null,
                sourceUrl: "https://blog.example/pho",
                baseServings: 4,
                totalMinutes: 90,
                difficulty: 3,
                ingredients: [{ name: "bánh phở", matchedName: null, ingredientId: null, isNew: true, quantity: 500, unit: "g", note: null }],
                steps: [{ text: "Chan nước dùng." }],
                suggestedTagIds: [],
              },
            }),
          )
        : { data: [], response: new Response(null, { status: 200 }) },
    );
    renderView();
    submitUrl("https://blog.example/pho");

    expect(await screen.findByDisplayValue("Phở bò")).toBeInTheDocument();
    expect(screen.getByRole("heading", { name: "Xem lại công thức đã nhập" })).toBeInTheDocument();
    expect(screen.getByDisplayValue("Chan nước dùng.")).toBeInTheDocument();
    // The unmatched ingredient is offered for one-click catalog creation.
    expect(screen.getByRole("button", { name: "Thêm 1 nguyên liệu mới vào danh mục" })).toBeInTheDocument();
  });

  it("explains a failed job in Vietnamese and lets the user retry", async () => {
    startUrlImport.mockResolvedValue(job({ cooldownSeconds: 60 }));
    get.mockImplementation(async () => respond(job({ status: "failed", errorCode: "fetch_failed" })));
    renderView();
    submitUrl("https://blocked.example/x");

    expect(await screen.findByRole("alert")).toHaveTextContent("Không tải được trang này");
    fireEvent.click(screen.getByRole("button", { name: "Thử lại" }));
    expect(screen.getByLabelText("Liên kết công thức")).toBeInTheDocument();
  });

  it("reports quota errors from starting the job", async () => {
    startUrlImport.mockRejectedValue(new ApiError(429, "Daily recipe import limit reached"));
    renderView();
    submitUrl("https://blog.example/pho");

    await waitFor(() => expect(screen.getByRole("alert")).toHaveTextContent("quá nhiều"));
    expect(screen.getByLabelText("Liên kết công thức")).toBeInTheDocument();
  });

  it("blocks a second import for a minute after one starts", async () => {
    startUrlImport.mockResolvedValue(job({ cooldownSeconds: 60 }));
    get.mockImplementation(async () => respond(job({ status: "failed", errorCode: "not_a_recipe" })));
    renderView();
    submitUrl("https://blog.example/a");

    await screen.findByRole("alert");
    fireEvent.click(screen.getByRole("button", { name: "Thử lại" }));

    expect(screen.getByRole("status")).toHaveTextContent("chờ 60 giây nữa");
    expect(screen.getByRole("button", { name: "Đọc công thức" })).toBeDisabled();
    fireEvent.change(screen.getByLabelText("Liên kết công thức"), { target: { value: "https://blog.example/b" } });
    expect(screen.getByRole("button", { name: "Đọc công thức" })).toBeDisabled();
    expect(startUrlImport).toHaveBeenCalledTimes(1);
  });

  it("adopts the wait time the server reports when it answers 429", async () => {
    startUrlImport.mockRejectedValue(new ApiError(429, "Please wait", 37));
    renderView();
    submitUrl("https://blog.example/pho");

    await waitFor(() => expect(screen.getByRole("status")).toHaveTextContent("37 giây nữa"));
    // Only the live countdown, no second, frozen number in an error line.
    expect(screen.queryByRole("alert")).not.toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Đọc công thức" })).toBeDisabled();
  });

  it("uses the cooldown length the server sent with the created job", async () => {
    startUrlImport.mockResolvedValue(job({ cooldownSeconds: 0 }));
    get.mockImplementation(async () => respond(job({ status: "failed", errorCode: "not_a_recipe" })));
    renderView();
    submitUrl("https://blog.example/a");

    await screen.findByRole("alert");
    fireEvent.click(screen.getByRole("button", { name: "Thử lại" }));
    expect(screen.queryByRole("status")).not.toBeInTheDocument();
  });

  it("does not start a cooldown when starting the job fails", async () => {
    startUrlImport.mockRejectedValue(new ApiError(503, "down"));
    renderView();
    submitUrl("https://blog.example/pho");

    await waitFor(() => expect(screen.getByRole("alert")).toHaveTextContent("không khả dụng"));
    expect(screen.queryByRole("status")).not.toBeInTheDocument();
  });

  it("switching between link and photo tabs never turns a controlled input uncontrolled", () => {
    const consoleError = vi.spyOn(console, "error").mockImplementation(() => undefined);
    renderView();
    fireEvent.change(screen.getByLabelText("Liên kết công thức"), { target: { value: "https://blog.example/a" } });
    fireEvent.click(screen.getByRole("tab", { name: "Ảnh công thức" }));
    fireEvent.click(screen.getByRole("tab", { name: "Dán liên kết" }));

    expect(screen.getByLabelText("Liên kết công thức")).toHaveValue("https://blog.example/a");
    expect(consoleError).not.toHaveBeenCalled();
    consoleError.mockRestore();
  });

  it("switches to the photo tab and starts an image import", async () => {
    startImageImport.mockResolvedValue(job({ cooldownSeconds: 60 }));
    renderView();
    fireEvent.click(screen.getByRole("tab", { name: "Ảnh công thức" }));
    const file = new File(["x"], "page.jpg", { type: "image/jpeg" });
    fireEvent.change(screen.getByLabelText("Ảnh trang sách hoặc thẻ công thức"), { target: { files: [file] } });
    fireEvent.click(screen.getByRole("button", { name: "Đọc công thức" }));

    await waitFor(() => expect(startImageImport).toHaveBeenCalledWith(file));
  });
});
