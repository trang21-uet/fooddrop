"use client";

import { useState, type FormEvent } from "react";
import { Button } from "@/components/ui/button";
import { FormField, inputClass } from "@/components/ui/form-field";
import { startTimer } from "./start-timer";
import { TimerList } from "./timer-list";

const MAX_MINUTES = 24 * 60;

export function TimersView() {
  const [label, setLabel] = useState("");
  const [minutes, setMinutes] = useState("10");
  const [error, setError] = useState<string | null>(null);

  const onSubmit = (event: FormEvent) => {
    event.preventDefault();
    const value = Number(minutes);
    if (!Number.isFinite(value) || value <= 0 || value > MAX_MINUTES) {
      setError(`Nhập số phút từ 1 đến ${MAX_MINUTES}.`);
      return;
    }
    setError(null);
    void startTimer(label, Math.round(value * 60_000));
    setLabel("");
  };

  return (
    <div className="flex max-w-2xl flex-col gap-7">
      <div className="flex flex-col gap-1.5">
        <h1 className="text-4xl leading-none font-extrabold tracking-tighter sm:text-[44px]">Hẹn giờ</h1>
        <p className="text-base text-muted">Chạy nhiều bộ đếm cùng lúc; vẫn còn sau khi tải lại trang.</p>
      </div>

      <form onSubmit={onSubmit} className="flex flex-wrap items-end gap-3 rounded-2xl border border-border bg-surface p-4">
        <div className="min-w-40 flex-1">
          <FormField label="Tên (tùy chọn)">
            <input className={inputClass} value={label} maxLength={60} placeholder="Luộc trứng" onChange={(e) => setLabel(e.target.value)} />
          </FormField>
        </div>
        <div className="w-28">
          <FormField label="Số phút" error={error ?? undefined}>
            <input
              className={inputClass}
              type="number"
              inputMode="decimal"
              min={1}
              max={MAX_MINUTES}
              step="any"
              value={minutes}
              aria-invalid={error ? true : undefined}
              onChange={(e) => setMinutes(e.target.value)}
            />
          </FormField>
        </div>
        <Button type="submit">Bắt đầu</Button>
      </form>

      <TimerList emptyText="Chưa có bộ đếm nào. Bắt đầu một bộ ở trên hoặc từ bước nấu trong công thức." />
    </div>
  );
}
