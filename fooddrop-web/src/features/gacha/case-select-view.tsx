"use client";

import { useState } from "react";
import { useSignOutOnUnauthorized } from "@/features/auth/use-sign-out-on-unauthorized";
import { CaseCard } from "./case-card";
import { CaseDetailPanel, OpenCaseButton } from "./case-detail-panel";
import { CASE_STYLES, type CaseId } from "./gacha-case-styles";
import { useGachaCasesQuery } from "./use-gacha-cases-query";

/** "Chọn hòm": pick a case, see what it holds, then open it on `/drop/[caseId]`. */
export function CaseSelectView() {
  const cases = useGachaCasesQuery();
  useSignOutOnUnauthorized(cases.error);
  const [selectedId, setSelectedId] = useState<CaseId>("all");
  const selected = cases.data?.find((item) => item.id === selectedId);

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
        <div className="flex flex-col gap-7 lg:flex-row lg:items-start">
          <section aria-label="Danh sách hòm" className="grid min-w-0 flex-1 grid-cols-2 gap-3 sm:gap-5 md:grid-cols-3 lg:grid-cols-[repeat(auto-fill,minmax(220px,1fr))]">
            {cases.data.map((item) => (
              <CaseCard key={item.id} item={item} selected={item.id === selectedId} onSelect={() => setSelectedId(item.id)} />
            ))}
          </section>
          {selected && <CaseDetailPanel item={selected} />}
        </div>
      )}

      {/* Below lg the detail panel sits under the grid, so the selected case and its button stay pinned. */}
      {selected && (
        <div
          className="fixed inset-x-0 bottom-0 z-30 flex flex-col gap-3 border-t bg-surface px-4 pt-3.5 pb-[max(14px,env(safe-area-inset-bottom))] lg:hidden"
          style={{ borderColor: CASE_STYLES[selected.id].color, boxShadow: `0 -10px 30px -12px ${CASE_STYLES[selected.id].color}aa` }}
        >
          <div className="flex items-center justify-between gap-3">
            <div className="flex min-w-0 flex-col">
              <span className="text-xs text-muted">Đã chọn</span>
              <span className="truncate text-lg font-extrabold">{CASE_STYLES[selected.id].name}</span>
            </div>
            <span className="shrink-0 font-mono text-[13px] text-muted">{selected.recipeCount} công thức</span>
          </div>
          <OpenCaseButton item={selected} />
        </div>
      )}
    </div>
  );
}
