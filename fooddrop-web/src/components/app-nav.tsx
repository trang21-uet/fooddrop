"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

// "Quay món" is a placeholder for a later phase (not a link, so no 404).
const NAV_ITEMS = [
  { label: "Công thức", href: "/recipes" },
  { label: "Quay món" },
  { label: "Đi chợ", href: "/grocery" },
  { label: "Hẹn giờ", href: "/timers" },
] as const;

const itemClass = "flex min-h-11 items-center border-b-2 px-3.5 text-[15px] whitespace-nowrap";

export function AppNav() {
  const pathname = usePathname();

  return (
    <nav aria-label="Điều hướng chính" className="flex flex-1 items-center gap-1 overflow-x-auto">
      {NAV_ITEMS.map((item) => {
        if (!("href" in item)) {
          return (
            <span
              key={item.label}
              aria-disabled="true"
              title="Sắp ra mắt"
              className={`${itemClass} cursor-not-allowed border-transparent font-medium text-muted/60`}
            >
              {item.label}
            </span>
          );
        }
        const active = pathname === item.href || pathname.startsWith(`${item.href}/`);
        return (
          <Link
            key={item.label}
            href={item.href}
            aria-current={active ? "page" : undefined}
            className={`${itemClass} ${active ? "border-accent font-semibold text-accent" : "border-transparent font-medium text-muted hover:text-foreground"}`}
          >
            {item.label}
          </Link>
        );
      })}
    </nav>
  );
}
