"use client";

import { useState } from "react";
import { useSignOutOnUnauthorized } from "@/features/auth/use-sign-out-on-unauthorized";
import { CaseCard } from "./case-card";
import { CaseDetailPanel, OpenCaseButton } from "./case-detail-panel";
import { CASE_TABS, caseStyle, type CaseGroup, type CaseId } from "./gacha-case-styles";
import { useGachaCasesQuery } from "./use-gacha-cases-query";

const PANEL_ID = "case-tab-panel";

/** "Chọn hòm": pick a tab and a case, see what it holds, then open it on `/drop/[caseId]`. */
export function CaseSelectView() {
  const cases = useGachaCasesQuery();
  useSignOutOnUnauthorized(cases.error);
  const [group, setGroup] = useState<CaseGroup>("featured");
  const [selectedId, setSelectedId] = useState<CaseId>("all");
  const visible = cases.data?.filter((item) => item.group === group) ?? [];
  const selected = visible.find((item) => item.id === selectedId);
  const tab = CASE_TABS.find((item) => item.group === group)!;
  const style = selected && caseStyle(selected);

  const openTab = (next: CaseGroup) => {
    setGroup(next);
    // Keep the detail panel on a case of the open tab.
    const first = cases.data?.find((item) => item.group === next);
    if (first) setSelectedId(first.id);
  };

  return (
    <div className="flex flex-col gap-7 pb-36 lg:pb-0">
      <div className="flex flex-col gap-2">
        <h1 className="text-4xl leading-none font-extrabold tracking-tighter sm:text-[44px]">Chọn hòm</h1>
        <p className="text-[17px] text-muted">Mỗi hòm chứa một nhóm món. Chọn hòm rồi mở để nhận món.</p>
      </div>

      {cases.isPending && <p className="text-muted">Đang tải các hòm…</p>}
      {cases.isError && (
        <p role="alert" className="text-danger">
          Không tải được các hòm.{" "}
          <button type="button" onClick={() => void cases.refetch()} className="underline">
            Thử lại
          </button>
        </p>
      )}

      {cases.data && (
        <div className="flex flex-col gap-5">
          <div role="tablist" aria-label="Nhóm hòm" className="-mx-4 flex gap-2 overflow-x-auto px-4 sm:mx-0 sm:flex-wrap sm:px-0">
            {CASE_TABS.map((item) => (
              <button
                key={item.group}
                type="button"
                role="tab"
                aria-selected={group === item.group}
                aria-controls={PANEL_ID}
                onClick={() => openTab(item.group)}
                className="min-h-11 shrink-0 rounded-xl border border-border px-4 text-sm font-semibold aria-selected:border-accent aria-selected:text-accent"
              >
                {item.label}
                <span className="ml-1.5 font-mono text-xs text-muted">{cases.data.filter((c) => c.group === item.group).length}</span>
              </button>
            ))}
          </div>

          <div id={PANEL_ID} role="tabpanel" aria-label={tab.label} className="flex flex-col gap-7 lg:flex-row lg:items-start">
            {visible.length === 0 ? (
              <p className="flex-1 rounded-[20px] border border-border bg-surface p-6 text-muted">
                Chưa có công thức nào gắn thẻ {tab.label.toLowerCase()}. Gắn thẻ cho công thức để có hòm ở đây.
              </p>
            ) : (
              <section aria-label="Danh sách hòm" className="grid min-w-0 flex-1 grid-cols-2 gap-3 sm:gap-5 md:grid-cols-3 lg:grid-cols-[repeat(auto-fill,minmax(220px,1fr))]">
                {visible.map((item) => (
                  <CaseCard key={item.id} item={item} selected={item.id === selectedId} onSelect={() => setSelectedId(item.id)} />
                ))}
              </section>
            )}
            {selected && <CaseDetailPanel item={selected} />}
          </div>
        </div>
      )}

      {/* Below lg the detail panel sits under the grid, so the selected case and its button stay pinned. */}
      {selected && style && (
        <div
          className="fixed inset-x-0 bottom-0 z-30 flex flex-col gap-3 border-t bg-surface px-4 pt-3.5 pb-[max(14px,env(safe-area-inset-bottom))] lg:hidden"
          style={{ borderColor: style.color, boxShadow: `0 -10px 30px -12px ${style.color}aa` }}
        >
          <div className="flex items-center justify-between gap-3">
            <div className="flex min-w-0 flex-col">
              <span className="text-xs text-muted">Đã chọn</span>
              <span className="truncate text-lg font-extrabold">{style.name}</span>
            </div>
            <span className="shrink-0 font-mono text-[13px] text-muted">{selected.recipeCount} công thức</span>
          </div>
          <OpenCaseButton item={selected} />
        </div>
      )}
    </div>
  );
}
