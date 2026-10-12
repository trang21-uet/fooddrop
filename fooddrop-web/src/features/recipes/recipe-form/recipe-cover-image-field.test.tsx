import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { FormProvider, useForm } from "react-hook-form";
import { EMPTY_RECIPE_FORM, type RecipeFormValues } from "./recipe-form-schema";
import { RecipeCoverImageField } from "./recipe-cover-image-field";

const uploadImage = vi.fn();
vi.mock("@/lib/images/upload-image", () => ({ uploadImage: (...args: unknown[]) => uploadImage(...args) }));

let latest: RecipeFormValues["coverImage"] = null;

function Harness({ initial = null }: { initial?: RecipeFormValues["coverImage"] }) {
  const methods = useForm<RecipeFormValues>({ defaultValues: { ...EMPTY_RECIPE_FORM, coverImage: initial } });
  latest = methods.watch("coverImage");
  return (
    <FormProvider {...methods}>
      <RecipeCoverImageField />
    </FormProvider>
  );
}

const choose = (file: File) => fireEvent.change(screen.getByLabelText("Chọn ảnh món từ máy"), { target: { files: [file] } });

describe("RecipeCoverImageField", () => {
  beforeEach(() => {
    uploadImage.mockReset();
    URL.createObjectURL = vi.fn((file: Blob) => `blob:${(file as File).name}`);
    URL.revokeObjectURL = vi.fn();
  });

  it("uploads a photo from the device, previews it and hides the URL field", async () => {
    uploadImage.mockResolvedValue("recipes/u1/cover.jpg");
    render(<Harness />);
    expect(screen.getByLabelText(/Hoặc dán đường dẫn ảnh/)).toBeInTheDocument();

    choose(new File(["x"], "cover.jpg", { type: "image/jpeg" }));

    expect(await screen.findByAltText("Xem trước ảnh món")).toHaveAttribute("src", "blob:cover.jpg");
    expect(uploadImage).toHaveBeenCalledWith(expect.any(File), "recipe-cover");
    expect(latest).toEqual({ key: "recipes/u1/cover.jpg", url: "blob:cover.jpg" });
    expect(screen.queryByLabelText(/Hoặc dán đường dẫn ảnh/)).not.toBeInTheDocument();
  });

  it("removes an uploaded photo and brings the URL field back", async () => {
    render(<Harness initial={{ key: "recipes/u1/cover.jpg", url: "https://cdn.example/cover.jpg" }} />);

    fireEvent.click(screen.getByRole("button", { name: "Xóa ảnh đã tải lên" }));

    await waitFor(() => expect(latest).toBeNull());
    expect(screen.getByLabelText(/Hoặc dán đường dẫn ảnh/)).toBeInTheDocument();
  });

  it("keeps the current photo and reports a failed upload", async () => {
    uploadImage.mockRejectedValue(new Error("Tải ảnh lên thất bại"));
    render(<Harness initial={{ key: "recipes/u1/old.jpg", url: "https://cdn.example/old.jpg" }} />);

    choose(new File(["x"], "new.jpg", { type: "image/jpeg" }));

    expect(await screen.findByRole("alert")).toHaveTextContent("Tải ảnh lên thất bại");
    expect(latest).toEqual({ key: "recipes/u1/old.jpg", url: "https://cdn.example/old.jpg" });
  });
});
