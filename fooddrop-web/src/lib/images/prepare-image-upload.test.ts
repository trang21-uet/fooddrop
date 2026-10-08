import { fitWithin } from "./prepare-image-upload";

describe("fitWithin", () => {
  it("shrinks the longer edge to the limit and keeps the aspect ratio", () => {
    expect(fitWithin(4000, 3000)).toEqual({ width: 2000, height: 1500 });
    expect(fitWithin(3000, 6000)).toEqual({ width: 1000, height: 2000 });
  });

  it("never enlarges small images", () => {
    expect(fitWithin(800, 600)).toEqual({ width: 800, height: 600 });
  });

  it("keeps at least one pixel per side", () => {
    expect(fitWithin(20_000, 1)).toEqual({ width: 2000, height: 1 });
  });
});
