import Image from "next/image";
import { Suspense } from "react";
import { LoginForm } from "@/features/auth/login-form";

export const metadata = { title: "Đăng nhập · Food Drop" };

export default function LoginPage() {
  return (
    <main className="flex min-h-screen flex-wrap bg-background">
      <section
        aria-label="Giới thiệu"
        className="hidden min-h-95 flex-[1_1_520px] flex-col gap-7 p-10 lg:flex"
      >
        <span className="text-[40px] leading-none font-extrabold tracking-[-0.03em]">Food Drop</span>
        <div className="flex flex-1 flex-col justify-center gap-7">
          <Image
            src="/auth-hero.jpg"
            alt="Khung neon cam chọn bánh mì giữa dải món ăn"
            width={2000}
            height={1125}
            sizes="50vw"
            className="h-auto w-full [mask-composite:intersect] [mask-image:linear-gradient(to_right,transparent,black_14%,black_86%,transparent),linear-gradient(to_bottom,transparent,black_8%,black_92%,transparent)]"
          />
          <div className="flex flex-col gap-2.5">
            <p className="max-w-lg text-4xl leading-[1.08] font-extrabold tracking-[-0.03em]">
              Mở hộp, nhận món, vào bếp.
            </p>
            <p className="max-w-lg text-base leading-normal text-muted">
              Lưu công thức của bạn, để Food Drop chọn bữa hôm nay và lo luôn danh sách đi chợ.
            </p>
          </div>
        </div>
      </section>
      <section
        aria-label="Đăng nhập"
        className="flex flex-[1_1_480px] items-center justify-center bg-[radial-gradient(520px_420px_at_50%_40%,color-mix(in_srgb,var(--accent)_10%,transparent),transparent_70%)] px-6 py-10"
      >
        <div className="glow-accent w-full max-w-[400px] rounded-[20px] bg-surface p-8">
          <Image
            src="/icon-192.png"
            alt=""
            width={56}
            height={56}
            className="mb-5 rounded-xl lg:hidden"
          />
          <Suspense>
            <LoginForm />
          </Suspense>
        </div>
      </section>
    </main>
  );
}
