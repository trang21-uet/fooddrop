import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { FormProvider, useForm } from "react-hook-form";
import { MAX_STEP_IMAGES, type RecipeFormValues, type StepImage } from "./recipe-form-schema";
import { StepImagesField } from "./step-images-field";

const uploadImage = vi.fn();
vi.mock("@/lib/images/upload-image", () => ({ uploadImage: (...args: unknown[]) => uploadImage(...args) }));

let latest: StepImage[] = [];

function Harness({ initial = [] }: { initial?: StepImage[] }) {
  const methods = useForm<Pick<RecipeFormValues, "steps">>({
    defaultValues: { steps: [{ name: "", text: "", images: initial }] },
  });
  latest = methods.watch("steps.0.images");
  return (
    <FormProvider {...(methods as unknown as ReturnType<typeof useForm<RecipeFormValues>>)}>
      <StepImagesField index={0} />
    </FormProvider>
  );
}

const photo = (name: string) => new File(["x"], name, { type: "image/jpeg" });
const chooseFiles = (files: File[]) =>
  fireEvent.change(screen.getByLabelText("Chọn ảnh cho bước 1"), { target: { files } });

describe("StepImagesField", () => {
  beforeEach(() => {
    uploadImage.mockReset();
    URL.createObjectURL = vi.fn((file: Blob) => `blob:${(file as File).name}`);
    URL.revokeObjectURL = vi.fn();
  });

  it("uploads several photos at once and previews each one", async () => {
    uploadImage.mockImplementation(async (file: File) => `recipes/u1/${file.name}`);
    render(<Harness />);

    chooseFiles([photo("a.jpg"), photo("b.jpg")]);

    expect(await screen.findByAltText("Ảnh 2 của bước 1")).toHaveAttribute("src", "blob:b.jpg");
    expect(uploadImage).toHaveBeenCalledWith(expect.any(File), "recipe-step");
    expect(latest.map((image) => image.key)).toEqual(["recipes/u1/a.jpg", "recipes/u1/b.jpg"]);
  });

  it("removes a photo from the step", async () => {
    render(<Harness initial={[{ key: "recipes/u1/a.jpg", url: "https://cdn.example/a.jpg" }]} />);

    fireEvent.click(screen.getByRole("button", { name: "Xóa ảnh 1 của bước 1" }));

    await waitFor(() => expect(latest).toEqual([]));
    expect(screen.queryByAltText("Ảnh 1 của bước 1")).not.toBeInTheDocument();
  });

  it("keeps the photos that uploaded and reports the one that failed", async () => {
    uploadImage.mockImplementation(async (file: File) => {
      if (file.name === "bad.jpg") throw new Error("Tải ảnh lên thất bại");
      return `recipes/u1/${file.name}`;
    });
    render(<Harness />);

    chooseFiles([photo("ok.jpg"), photo("bad.jpg")]);

    expect(await screen.findByRole("alert")).toHaveTextContent("Tải ảnh lên thất bại");
    expect(latest.map((image) => image.key)).toEqual(["recipes/u1/ok.jpg"]);
  });

  it("stops accepting photos at the per-step limit", async () => {
    const full = Array.from({ length: MAX_STEP_IMAGES }, (_, i) => ({ key: `recipes/u1/${i}.jpg`, url: null }));
    render(<Harness initial={full} />);

    expect(screen.getByLabelText("Chọn ảnh cho bước 1")).toBeDisabled();
  });
});
