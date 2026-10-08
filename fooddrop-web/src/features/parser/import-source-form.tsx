"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { FormField, inputClass } from "@/components/ui/form-field";

type Mode = "url" | "photo";

interface ImportSourceFormProps {
  disabled: boolean;
  /** Seconds until another import is allowed; the submit button stays disabled while > 0. */
  cooldownSeconds: number;
  error: string | null;
  onSubmitUrl: (url: string) => void;
  onSubmitPhoto: (file: File) => void;
}

const TABS: Array<{ mode: Mode; label: string }> = [
  { mode: "url", label: "Dán liên kết" },
  { mode: "photo", label: "Ảnh công thức" },
];

export function ImportSourceForm({ disabled, cooldownSeconds, error, onSubmitUrl, onSubmitPhoto }: ImportSourceFormProps) {
  const [mode, setMode] = useState<Mode>("url");
  const [url, setUrl] = useState("");
  const [file, setFile] = useState<File | null>(null);

  const submit = (event: React.FormEvent) => {
    event.preventDefault();
    if (mode === "url") onSubmitUrl(url.trim());
    else if (file) onSubmitPhoto(file);
  };
  const canSubmit = !disabled && cooldownSeconds === 0 && (mode === "url" ? url.trim().length > 0 : file !== null);

  return (
    <form onSubmit={submit} className="flex max-w-xl flex-col gap-5">
      <div role="tablist" aria-label="Nguồn công thức" className="flex gap-2">
        {TABS.map((tab) => (
          <button
            key={tab.mode}
            type="button"
            role="tab"
            aria-selected={mode === tab.mode}
            onClick={() => setMode(tab.mode)}
            className="min-h-11 rounded-xl border border-border px-4 text-sm font-semibold aria-selected:border-accent aria-selected:text-accent"
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* Distinct keys: otherwise React reuses one <input> DOM node and flips it from controlled (url) to uncontrolled (file). */}
      {mode === "url" ? (
        <FormField key="url" label="Liên kết công thức" hint="Hoạt động tốt nhất với các blog nấu ăn công khai.">
          <input
            type="url"
            inputMode="url"
            value={url}
            onChange={(event) => setUrl(event.target.value)}
            placeholder="https://…"
            className={inputClass}
          />
        </FormField>
      ) : (
        <FormField key="photo" label="Ảnh trang sách hoặc thẻ công thức" hint="Chụp thẳng, đủ sáng, thấy cả nguyên liệu và các bước.">
          <input
            type="file"
            accept="image/jpeg,image/png,image/webp"
            onChange={(event) => setFile(event.target.files?.[0] ?? null)}
            className={inputClass}
          />
        </FormField>
      )}

      {error && (
        <p role="alert" className="text-sm text-danger">
          {error}
        </p>
      )}
      {cooldownSeconds > 0 && (
        <p role="status" className="text-sm text-muted">
          Bạn vừa nhập một công thức. Hãy chờ {cooldownSeconds} giây nữa để nhập tiếp.
        </p>
      )}
      <Button type="submit" disabled={!canSubmit} className="self-start">
        {disabled ? "Đang gửi…" : "Đọc công thức"}
      </Button>
    </form>
  );
}
