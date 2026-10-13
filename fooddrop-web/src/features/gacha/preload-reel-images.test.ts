import type { GachaRecipeCard, GachaSpin } from "./gacha-types";
import { preloadReelImages, slowCardImageUrls } from "./preload-reel-images";

const card = (i: number): GachaRecipeCard => ({
  id: `r${i}`,
  title: `Món ${i}`,
  imageUrl: i % 10 === 9 ? null : `https://cdn.test/${i}.jpg`,
  rarity: "white",
  totalMinutes: 10,
  difficulty: 1,
  baseServings: 2,
});
const spin = { reel: Array.from({ length: 70 }, (_, i) => card(i)), winningIndex: 60 } as GachaSpin;

describe("slowCardImageUrls", () => {
  it("takes the opening screen and the cards around the winner, skipping cards without a photo", () => {
    const urls = slowCardImageUrls(spin);
    expect(urls).toContain("https://cdn.test/0.jpg");
    expect(urls).toContain("https://cdn.test/7.jpg");
    expect(urls).not.toContain("https://cdn.test/8.jpg");
    expect(urls).toContain("https://cdn.test/55.jpg");
    expect(urls).toContain("https://cdn.test/65.jpg");
    expect(urls).not.toContain("https://cdn.test/59.jpg"); // no photo
    expect(urls).not.toContain("https://cdn.test/66.jpg");
  });
});

describe("preloadReelImages", () => {
  const created: Array<{ src: string; onload?: () => void; onerror?: () => void }> = [];

  beforeEach(() => {
    created.length = 0;
    vi.stubGlobal(
      "Image",
      class {
        onload?: () => void;
        onerror?: () => void;
        src = "";
        constructor() {
          created.push(this);
        }
      },
    );
  });
  afterEach(() => vi.unstubAllGlobals());

  it("starts every photo once and resolves when the slow cards are ready", async () => {
    const done = preloadReelImages(spin, 10_000);
    const unique = new Set(spin.reel.flatMap((c) => (c.imageUrl ? [c.imageUrl] : [])));
    expect(created).toHaveLength(unique.size);

    let resolved = false;
    void done.then(() => (resolved = true));
    const slow = new Set(slowCardImageUrls(spin));
    created.filter((image) => slow.has(image.src)).forEach((image, i) => (i % 2 ? image.onerror?.() : image.onload?.()));
    await done;
    expect(resolved).toBe(true);
  });

  it("gives up waiting after the timeout", async () => {
    vi.useFakeTimers();
    const done = preloadReelImages(spin, 1500);
    await vi.advanceTimersByTimeAsync(1500);
    await expect(done).resolves.toBeUndefined();
    vi.useRealTimers();
  });
});
