import { render, screen } from "@testing-library/react";
import Home from "./page";

describe("Home page", () => {
  it("shows the Food Drop brand", () => {
    render(<Home />);
    expect(screen.getByRole("heading", { name: "Food Drop" })).toBeInTheDocument();
    expect(screen.getByAltText("Food Drop logo")).toBeInTheDocument();
  });
});
