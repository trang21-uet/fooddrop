import { ApiError } from "@/lib/api/api-error";
import { defaultUnitForRowUnit, ensureIngredient } from "./ensure-ingredient";

const post = vi.fn();
const get = vi.fn();
vi.mock("@/lib/api/api-client", () => ({ apiClient: { POST: (...a: unknown[]) => post(...a), GET: (...a: unknown[]) => get(...a) } }));

const ingredient = (name: string, aliases: string[] = []) => ({
  id: "i1", name, aliases, aisle: "other", defaultUnit: "g", densityGPerMl: null, isFermented: false,
});
const ok = (data: unknown, status = 200) => ({ data, response: new Response(null, { status }) });

const units = [
  { code: "g", nameVi: "g", nameEn: "g", kind: "mass" },
  { code: "tbsp", nameVi: "thìa canh", nameEn: "tablespoon", kind: "volume" },
  { code: "fruit", nameVi: "quả", nameEn: "fruit", kind: "count" },
  { code: "pinch", nameVi: "nhúm", nameEn: "pinch", kind: "other" },
] as const;

describe("defaultUnitForRowUnit", () => {
  it("maps the row unit to how the ingredient is aggregated", () => {
    expect(defaultUnitForRowUnit("", units)).toBe("piece");
    expect(defaultUnitForRowUnit("fruit", units)).toBe("piece");
    expect(defaultUnitForRowUnit("tbsp", units)).toBe("ml");
    expect(defaultUnitForRowUnit("g", units)).toBe("g");
    expect(defaultUnitForRowUnit("pinch", units)).toBe("g");
  });

  it("falls back to pieces while the unit catalog is still loading", () => {
    expect(defaultUnitForRowUnit("tbsp", [])).toBe("piece");
  });
});

describe("ensureIngredient", () => {
  beforeEach(() => {
    post.mockReset();
    get.mockReset();
  });

  it("creates a new catalog entry with the given default unit", async () => {
    post.mockResolvedValue(ok(ingredient("Trứng cút"), 201));
    expect((await ensureIngredient("Trứng cút", "piece")).name).toBe("Trứng cút");
    expect(post).toHaveBeenCalledWith("/ingredients", { body: expect.objectContaining({ name: "Trứng cút", defaultUnit: "piece" }) });
  });

  it("falls back to the existing entry when the name or an alias already exists", async () => {
    post.mockResolvedValue({ error: { message: "exists" }, response: new Response(null, { status: 409 }) });
    get.mockResolvedValue(ok([ingredient("Hành lá", ["scallion"])]));
    expect((await ensureIngredient("Scallion", "g")).name).toBe("Hành lá");
  });

  it("rethrows other failures", async () => {
    post.mockResolvedValue({ error: { message: "boom" }, response: new Response(null, { status: 500 }) });
    await expect(ensureIngredient("x", "g")).rejects.toBeInstanceOf(ApiError);
    expect(get).not.toHaveBeenCalled();
  });
});
