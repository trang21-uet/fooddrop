"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useRouter, useSearchParams } from "next/navigation";
import { useState } from "react";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { Button } from "@/components/ui/button";
import { FormField } from "@/components/ui/form-field";
import { authClient } from "@/lib/auth-client";
import { authErrorMessage } from "./auth-error-message";
import { authInputClass } from "./auth-input-class";
import { PasswordInput } from "./password-input";
import { safeRedirectPath } from "./safe-redirect-path";

const loginSchema = z.object({
  name: z.string().trim().max(100),
  email: z.email("Nhập email hợp lệ"),
  password: z.string().min(8, "Mật khẩu cần ít nhất 8 ký tự.").max(128),
});
type LoginValues = z.infer<typeof loginSchema>;

export function LoginForm() {
  const router = useRouter();
  const nextPath = safeRedirectPath(useSearchParams().get("next"));
  const [mode, setMode] = useState<"sign-in" | "sign-up">("sign-in");
  const [serverError, setServerError] = useState<string | null>(null);
  const {
    register,
    handleSubmit,
    setError,
    formState: { errors, isSubmitting },
  } = useForm<LoginValues>({
    resolver: zodResolver(loginSchema),
    // `name` is only rendered when signing up; without a default it would be undefined and fail validation invisibly.
    defaultValues: { name: "", email: "", password: "" },
  });

  const isSignUp = mode === "sign-up";

  const onSubmit = async (values: LoginValues) => {
    setServerError(null);
    if (isSignUp && !values.name) {
      setError("name", { message: "Cho mình biết cách gọi bạn nhé" });
      return;
    }
    try {
      const { error } = isSignUp
        ? await authClient.signUp.email({ email: values.email, password: values.password, name: values.name })
        : await authClient.signIn.email({ email: values.email, password: values.password });
      if (error) {
        setServerError(authErrorMessage(error));
        return;
      }
      router.replace(nextPath);
      router.refresh();
    } catch {
      setServerError("Không kết nối được máy chủ. Thử lại nhé.");
    }
  };

  return (
    <>
      <h1 className="text-3xl font-extrabold tracking-[-0.02em]">{isSignUp ? "Tạo tài khoản" : "Đăng nhập"}</h1>
      <p className="mt-1.5 mb-6 text-sm text-muted">
        {isSignUp ? "Chỉ mất chưa đầy một phút." : "Chào mừng quay lại bếp của bạn."}
      </p>
      <form onSubmit={handleSubmit(onSubmit)} noValidate className="flex flex-col gap-4.5">
        {isSignUp && (
          <FormField label="Tên hiển thị" error={errors.name?.message}>
            <input {...register("name")} autoComplete="name" placeholder="Trang" className={authInputClass} />
          </FormField>
        )}
        <FormField label="Email" error={errors.email?.message}>
          <input
            {...register("email")}
            type="email"
            autoComplete="email"
            placeholder="ban@vidu.com"
            className={authInputClass}
          />
        </FormField>
        <FormField label="Mật khẩu" error={errors.password?.message}>
          <PasswordInput
            {...register("password")}
            autoComplete={isSignUp ? "new-password" : "current-password"}
            placeholder="Ít nhất 8 ký tự"
          />
        </FormField>
        {serverError && (
          <p role="alert" className="text-sm text-danger">
            {serverError}
          </p>
        )}
        <Button
          type="submit"
          size="lg"
          disabled={isSubmitting}
          className="mt-1 shadow-[0_0_22px_-4px_color-mix(in_srgb,var(--accent)_70%,transparent)]"
        >
          {isSubmitting ? "Vui lòng chờ…" : isSignUp ? "Tạo tài khoản" : "Đăng nhập"}
        </Button>
      </form>
      <p className="mt-5.5 text-center text-sm text-muted">
        {isSignUp ? "Đã có tài khoản?" : "Mới dùng Food Drop?"}
        <button
          type="button"
          onClick={() => {
            setMode(isSignUp ? "sign-in" : "sign-up");
            setServerError(null);
          }}
          className="ml-1 inline-flex min-h-11 items-center font-bold text-accent hover:underline hover:underline-offset-4"
        >
          {isSignUp ? "Đăng nhập" : "Tạo tài khoản"}
        </button>
      </p>
    </>
  );
}
