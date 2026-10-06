import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { RecipeForm } from "./recipe-form";

const push = vi.fn();
const post = vi.fn();

vi.mock("next/navigation", () => ({
  useRouter: () => ({ push, replace: vi.fn(), refresh: vi.fn(), back: vi.fn() }),
}));

vi.mock("@/lib/api/api-client", () => ({
  apiClient: {
    GET: vi.fn(async (path: string) => ({
      data: path === "/tags" ? [] : [],
      response: new Response(null, { status: 200 }),
    })),
    POST: (...args: unknown[]) => post(...args),
    PUT: vi.fn(),
  },
}));

function renderForm() {
  const client = new QueryClient({ defaultOptions: { queries: { retry: false } } });
  return render(
    <QueryClientProvider client={client}>
      <RecipeForm />
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
    fireEvent.change(screen.getByLabelText("Bước 1"), { target: { value: "Fry it" } });
    fireEvent.click(screen.getByRole("button", { name: "Lưu công thức" }));

    expect(await screen.findByText("Chọn một nguyên liệu trong danh sách")).toBeInTheDocument();
    expect(post).not.toHaveBeenCalled();
  });

  it("submits a valid recipe and navigates to its detail page", async () => {
    post.mockResolvedValue({ data: { id: "abc" }, response: new Response(null, { status: 201 }) });
    renderForm();
    fireEvent.change(screen.getByLabelText("Tiêu đề"), { target: { value: "Egg rice" } });
    fireEvent.change(screen.getByLabelText("Bước 1"), { target: { value: "Fry it" } });
    fireEvent.change(screen.getByLabelText("Hẹn giờ (phút, không bắt buộc)"), { target: { value: "2" } });
    fireEvent.click(screen.getByRole("button", { name: "Lưu công thức" }));

    await waitFor(() => expect(push).toHaveBeenCalledWith("/recipes/abc"));
    expect(post).toHaveBeenCalledWith("/recipes", {
      body: expect.objectContaining({
        title: "Egg rice",
        description: null,
        baseServings: 2,
        steps: [{ text: "Fry it", timerSeconds: 120 }],
        ingredients: [],
      }),
    });
  });

  it("shows the server's message when saving fails", async () => {
    post.mockResolvedValue({
      error: { message: "Title already used" },
      response: new Response(null, { status: 400 }),
    });
    renderForm();
    fireEvent.change(screen.getByLabelText("Tiêu đề"), { target: { value: "Egg rice" } });
    fireEvent.change(screen.getByLabelText("Bước 1"), { target: { value: "Fry it" } });
    fireEvent.click(screen.getByRole("button", { name: "Lưu công thức" }));

    expect(await screen.findByText("Title already used")).toBeInTheDocument();
    expect(push).not.toHaveBeenCalled();
  });
});
