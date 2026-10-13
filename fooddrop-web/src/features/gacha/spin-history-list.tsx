"use client";

import Link from "next/link";
import { RARITY_STYLES } from "../recipes/rarity-badge";
import { useSpinHistoryQuery } from "./use-spin-history-query";

const timeFormat = new Intl.DateTimeFormat("vi-VN", { hour: "2-digit", minute: "2-digit", day: "2-digit", month: "2-digit" });

/** Latest spins. Refreshed only after the reel lands, so it never spoils a result mid-spin. */
export function SpinHistoryList() {
  const history = useSpinHistoryQuery();
  const items = history.data?.items ?? [];

  return (
    <section aria-labelledby="spin-history-title" className="flex flex-col gap-3 rounded-2xl border border-border bg-surface p-5">
      <h2 id="spin-history-title" className="text-[15px] font-bold">
        Lần quay gần đây
      </h2>
      {history.isPending && <p className="text-sm text-muted">Đang tải…</p>}
      {history.isError && <p className="text-sm text-danger">Không tải được lịch sử.</p>}
      {history.isSuccess && items.length === 0 && <p className="text-sm text-muted">Chưa quay lần nào.</p>}
      <ul className="flex flex-col gap-1">
        {items.map((item) => (
          <li key={item.id} className="flex items-center gap-3 text-sm">
            <span
              aria-hidden
              className="size-2.5 shrink-0 rounded-full"
              style={{ backgroundColor: item.result ? RARITY_STYLES[item.result.rarity].color : "var(--border)" }}
            />
            {item.result ? (
              <Link href={`/recipes/${item.result.id}`} className="min-w-0 flex-1 truncate py-1.5 hover:text-accent">
                {item.result.title}
              </Link>
            ) : (
              <span className="flex-1 py-1.5 text-muted italic">Món đã xóa</span>
            )}
            <time dateTime={item.createdAt} className="shrink-0 text-xs text-muted tabular-nums">
              {timeFormat.format(new Date(item.createdAt))}
            </time>
          </li>
        ))}
      </ul>
    </section>
  );
}
