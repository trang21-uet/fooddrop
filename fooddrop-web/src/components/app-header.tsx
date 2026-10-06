import Image from "next/image";
import Link from "next/link";
import { UserMenu } from "./user-menu";

// Only Recipes exists yet; the rest are placeholders for later phases (not links, so no 404s).
const NAV_ITEMS = [
  { label: "Công thức", href: "/recipes" },
  { label: "Quay món" },
  { label: "Đi chợ" },
  { label: "Hẹn giờ" },
] as const;

export function AppHeader() {
  return (
    <header className="sticky top-0 z-20 border-b border-border bg-background/90 backdrop-blur">
      <div className="mx-auto flex h-14 max-w-6xl items-center gap-4 px-4">
        <Link href="/recipes" aria-label="Food Drop" className="flex items-center gap-2 font-bold tracking-tight">
          <Image src="/icon-192.png" alt="" width={32} height={32} className="rounded-md" />
          <span className="hidden sm:inline">Food Drop</span>
        </Link>
        <nav aria-label="Điều hướng chính" className="flex flex-1 items-center gap-1 overflow-x-auto">
          {NAV_ITEMS.map((item) =>
            "href" in item ? (
              <Link
                key={item.label}
                href={item.href}
                className="rounded-md px-3 py-1.5 text-sm font-medium hover:bg-surface-raised"
              >
                {item.label}
              </Link>
            ) : (
              <span
                key={item.label}
                aria-disabled="true"
                title="Sắp ra mắt"
                className="hidden cursor-not-allowed rounded-md px-3 py-1.5 text-sm font-medium text-muted/60 sm:inline"
              >
                {item.label}
              </span>
            ),
          )}
        </nav>
        <UserMenu />
      </div>
    </header>
  );
}
