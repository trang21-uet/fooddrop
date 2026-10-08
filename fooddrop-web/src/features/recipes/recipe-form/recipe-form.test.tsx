import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { RecipeForm } from "./recipe-form";
import { EMPTY_RECIPE_FORM, type RecipeFormValues } from "./recipe-form-schema";

const push = vi.fn();
const post = vi.fn();
const uploadImage = vi.fn();

vi.mock("@/lib/images/upload-image", () => ({ uploadImage: (...args: unknown[]) => uploadImage(...args) }));

vi.mock("next/navigation", () => ({
  useRouter: () => ({ push, replace: vi.fn(), refresh: vi.fn(), back: vi.fn() }),
}));

vi.mock("@/lib/api/api-client", () => ({
  apiClient: {
    GET: vi.fn(async (path: string) => ({
      data: path === "/units" ? [{ code: "tbsp", nameVi: "thìa canh", nameEn: "tablespoon", kind: "volume" }] : [],
      response: new Response(null, { status: 200 }),
    })),
    POST: (...args: unknown[]) => post(...args),
    PUT: vi.fn(),
  },
}));

function renderForm(initialValues?: RecipeFormValues) {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(
    <QueryClientProvider client={client}>
      <RecipeForm initialValues={initialValues} />
    </QueryClientProvider>,
  );
}

describe("RecipeForm", () => {
  beforeEach(() => {
    push.mockClear();
    post.mockReset();
  });

  it("shows validation errors and does not call the API when required fields are missing", async () => {
    renderForm();
    fireEvent.click(screen.getByRole("button", { name: "Lưu công thức" }));

    expect(await screen.findByText("Cần nhập tiêu đề")).toBeInTheDocument();
    expect(screen.getByText("Hãy mô tả bước này")).toBeInTheDocument();
    expect(post).not.toHaveBeenCalled();
  });

  it("requires an ingredient to be picked from the catalog", async () => {
    renderForm();
    fireEvent.click(screen.getByRole("button", { name: "Thêm nguyên liệu" }));
    fireEvent.change(screen.getByLabelText("Tiêu đề"), { target: { value: "Egg rice" } });
    fireEvent.change(screen.getByLabelText("Nội dung bước 1"), { target: { value: "Fry it" } });
    fireEvent.click(screen.getByRole("button", { name: "Lưu công thức" }));

    expect(await screen.findByText("Chọn một nguyên liệu trong danh sách")).toBeInTheDocument();
    expect(post).not.toHaveBeenCalled();
  });

  it("submits a valid recipe and navigates to its detail page", async () => {
    post.mockResolvedValue({ data: { id: "abc" }, response: new Response(null, { status: 201 }) });
    renderForm();
    fireEvent.change(screen.getByLabelText("Tiêu đề"), { target: { value: "Egg rice" } });
    fireEvent.change(screen.getByLabelText("Tên bước 1 (không bắt buộc)"), { target: { value: "Chiên" } });
    fireEvent.change(screen.getByLabelText("Nội dung bước 1"), { target: { value: "Fry it" } });
    fireEvent.change(screen.getByLabelText("Hẹn giờ (phút, không bắt buộc)"), { target: { value: "2" } });
    fireEvent.click(screen.getByRole("button", { name: "Lưu công thức" }));

    await waitFor(() => expect(push).toHaveBeenCalledWith("/recipes/abc"));
    expect(post).toHaveBeenCalledWith("/recipes", {
      body: expect.objectContaining({
        title: "Egg rice",
        description: null,
        baseServings: 2,
        steps: [{ name: "Chiên", text: "Fry it", images: [], timerSeconds: 120 }],
        ingredients: [],
      }),
    });
  });

  it("keeps saving disabled while a step photo is still uploading, so the photo is not dropped", async () => {
    let finish: (key: string) => void = () => {};
    uploadImage.mockReturnValue(new Promise<string>((resolve) => (finish = resolve)));
    URL.createObjectURL = vi.fn(() => "blob:photo");
    post.mockResolvedValue({ data: { id: "abc" }, response: new Response(null, { status: 201 }) });
    renderForm();
    fireEvent.change(screen.getByLabelText("Tiêu đề"), { target: { value: "Egg rice" } });
    fireEvent.change(screen.getByLabelText("Nội dung bước 1"), { target: { value: "Fry it" } });

    fireEvent.change(screen.getByLabelText("Chọn ảnh cho bước 1"), {
      target: { files: [new File(["x"], "a.jpg", { type: "image/jpeg" })] },
    });

    expect(await screen.findByRole("button", { name: "Đang tải ảnh…" })).toBeDisabled();
    finish("recipes/u1/a.jpg");
    const save = await screen.findByRole("button", { name: "Lưu công thức" });
    expect(save).toBeEnabled();
    fireEvent.click(save);

    await waitFor(() => expect(post).toHaveBeenCalled());
    expect(post.mock.calls[0]![1].body.steps[0].images).toEqual(["recipes/u1/a.jpg"]);
  });

  it("still shows a saved unit while the unit catalog has not loaded", () => {
    renderForm({
      ...EMPTY_RECIPE_FORM,
      ingredients: [{ ingredientId: "i1", ingredientName: "Nước mắm", quantity: "2", unit: "tbsp", note: "" }],
    });
    expect(screen.getByRole("option", { name: "tbsp" })).toBeInTheDocument();
  });

  it("shows the server's message when saving fails", async () => {
    post.mockResolvedValue({
      error: { message: "Title already used" },
      response: new Response(null, { status: 400 }),
    });
    renderForm();
    fireEvent.change(screen.getByLabelText("Tiêu đề"), { target: { value: "Egg rice" } });
    fireEvent.change(screen.getByLabelText("Nội dung bước 1"), { target: { value: "Fry it" } });
    fireEvent.click(screen.getByRole("button", { name: "Lưu công thức" }));

    expect(await screen.findByText("Title already used")).toBeInTheDocument();
    expect(push).not.toHaveBeenCalled();
  });
});
