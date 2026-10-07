import Image from "next/image";
import Link from "next/link";
import { AppNav } from "./app-nav";
import { buttonClass } from "./ui/button";
import { PlusIcon } from "./ui/icons";
import { UserMenu } from "./user-menu";

export function AppHeader() {
  return (
    <header className="sticky top-0 z-20 border-b border-border bg-surface">
      <div className="flex flex-wrap items-center gap-x-8 gap-y-2 px-4 py-3 sm:px-8">
        <Link href="/recipes" aria-label="Food Drop" className="flex min-h-11 items-center gap-3">
          <Image src="/icon-192.png" alt="" width={36} height={36} className="rounded-[9px]" />
          <span className="hidden text-[19px] font-extrabold tracking-tight sm:inline">Food Drop</span>
        </Link>
        <AppNav />
        <div className="flex items-center gap-3">
          <Link href="/recipes/new" className={buttonClass("primary")}>
            <PlusIcon />
            Thêm công thức
          </Link>
          <UserMenu />
        </div>
      </div>
    </header>
  );
}
