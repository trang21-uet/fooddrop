import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { LoginForm } from "./login-form";

const replace = vi.fn();
const signIn = vi.fn();
const signUp = vi.fn();
let nextParam: string | null = null;

vi.mock("next/navigation", () => ({
  useRouter: () => ({ replace, refresh: vi.fn() }),
  useSearchParams: () => new URLSearchParams(nextParam ? { next: nextParam } : {}),
}));

vi.mock("@/lib/auth-client", () => ({
  authClient: {
    signIn: { email: (...args: unknown[]) => signIn(...args) },
    signUp: { email: (...args: unknown[]) => signUp(...args) },
  },
}));

function fill(email: string, password: string) {
  fireEvent.change(screen.getByLabelText("Email"), { target: { value: email } });
  fireEvent.change(screen.getByLabelText("Mật khẩu"), { target: { value: password } });
}

describe("LoginForm", () => {
  beforeEach(() => {
    replace.mockClear();
    signIn.mockReset();
    signUp.mockReset();
    nextParam = null;
  });

  it("signs in without a name field and goes to /recipes", async () => {
    signIn.mockResolvedValue({ error: null });
    render(<LoginForm />);
    fill("cook@example.test", "correct-horse");
    fireEvent.click(screen.getByRole("button", { name: "Đăng nhập" }));

    await waitFor(() => expect(replace).toHaveBeenCalledWith("/recipes"));
    expect(signIn).toHaveBeenCalledWith({ email: "cook@example.test", password: "correct-horse" });
  });

  it("returns to a safe ?next= path but ignores external ones", async () => {
    signIn.mockResolvedValue({ error: null });
    nextParam = "https://evil.test";
    render(<LoginForm />);
    fill("cook@example.test", "correct-horse");
    fireEvent.click(screen.getByRole("button", { name: "Đăng nhập" }));
    await waitFor(() => expect(replace).toHaveBeenCalledWith("/recipes"));
  });

  it("validates email and password before calling the server", async () => {
    render(<LoginForm />);
    fill("not-an-email", "short");
    fireEvent.click(screen.getByRole("button", { name: "Đăng nhập" }));

    expect(await screen.findByText("Nhập email hợp lệ")).toBeInTheDocument();
    expect(screen.getByText("Mật khẩu cần ít nhất 8 ký tự.")).toBeInTheDocument();
    expect(signIn).not.toHaveBeenCalled();
  });

  it("shows the server error and stays on the page", async () => {
    signIn.mockResolvedValue({ error: { code: "INVALID_EMAIL_OR_PASSWORD", message: "Invalid email or password" } });
    render(<LoginForm />);
    fill("cook@example.test", "wrong-password");
    fireEvent.click(screen.getByRole("button", { name: "Đăng nhập" }));

    expect(await screen.findByText("Email hoặc mật khẩu không đúng.")).toBeInTheDocument();
    expect(replace).not.toHaveBeenCalled();
  });

  it("toggles password visibility without changing the field's label", () => {
    render(<LoginForm />);
    const password = screen.getByLabelText("Mật khẩu");
    expect(password).toHaveAttribute("type", "password");

    fireEvent.click(screen.getByRole("button", { name: "Hiện mật khẩu" }));
    expect(password).toHaveAttribute("type", "text");

    fireEvent.click(screen.getByRole("button", { name: "Ẩn mật khẩu" }));
    expect(password).toHaveAttribute("type", "password");
  });

  it("requires a name when creating an account", async () => {
    render(<LoginForm />);
    fireEvent.click(screen.getByRole("button", { name: "Tạo tài khoản" }));
    fill("new@example.test", "correct-horse");
    fireEvent.click(screen.getByRole("button", { name: "Tạo tài khoản" }));
    expect(await screen.findByText("Cho mình biết cách gọi bạn nhé")).toBeInTheDocument();

    signUp.mockResolvedValue({ error: null });
    fireEvent.change(screen.getByLabelText("Tên hiển thị"), { target: { value: "Nova" } });
    fireEvent.click(screen.getByRole("button", { name: "Tạo tài khoản" }));
    await waitFor(() => expect(replace).toHaveBeenCalledWith("/recipes"));
    expect(signUp).toHaveBeenCalledWith({ email: "new@example.test", password: "correct-horse", name: "Nova" });
  });
});
