"use client";

import { useMemo, useState } from "react";
import { Button } from "@/components/ui/button";
import { useSignOutOnUnauthorized } from "@/features/auth/use-sign-out-on-unauthorized";
import { RecipeForm } from "../recipes/recipe-form/recipe-form";
import { draftToFormValues } from "./draft-to-form-values";
import { ImportSourceForm } from "./import-source-form";
import { InDevelopmentBadge } from "./in-development-badge";
import { parseErrorMessage, startErrorMessage } from "./parse-error-message";
import { startImageImport, startUrlImport } from "./start-import";
import { useParseJob } from "./use-parse-job";

/** Import flow: choose a source → wait for the job → review the draft in the regular recipe form. */
export function RecipeImportView() {
  const [jobId, setJobId] = useState<string | null>(null);
  const [starting, setStarting] = useState(false);
  const [startError, setStartError] = useState<string | null>(null);
  const job = useParseJob(jobId);
  useSignOutOnUnauthorized(job.error);

  const draft = job.data?.status === "succeeded" ? job.data.result : null;
  const initialValues = useMemo(() => (draft ? draftToFormValues(draft) : null), [draft]);

  const start = async (run: () => Promise<string>) => {
    setStarting(true);
    setStartError(null);
    try {
      setJobId(await run());
    } catch (error) {
      setStartError(startErrorMessage(error));
    } finally {
      setStarting(false);
    }
  };
  const reset = () => {
    setJobId(null);
    setStartError(null);
  };

  if (initialValues) {
    return (
      <div className="flex flex-col gap-6">
        <p className="max-w-3xl rounded-xl border border-border bg-surface p-4 text-sm text-muted">
          Công thức được đọc tự động nên có thể chưa chính xác. Hãy kiểm tra nguyên liệu, số lượng và các bước trước khi lưu.
          {draft?.ingredients.some((item) => item.isNew) && " Nguyên liệu chưa có trong danh mục cần được thêm vào."}
        </p>
        <RecipeForm heading="Xem lại công thức đã nhập" offerBulkIngredientAdd initialValues={initialValues} />
      </div>
    );
  }

  const failed = job.data?.status === "failed";
  const waiting = jobId !== null && !failed && !job.isError;
  return (
    <div className="flex flex-col gap-6">
      <div className="flex flex-col gap-1.5">
        <div className="flex items-center gap-3">
          <h1 className="text-2xl font-bold tracking-tight">Nhập công thức</h1>
          <InDevelopmentBadge />
        </div>
        <p className="text-sm text-muted">Dán liên kết hoặc chụp ảnh công thức, Food Drop sẽ tạo bản nháp để bạn chỉnh sửa.</p>
        <p className="text-sm text-muted">Tính năng đang được phát triển nên kết quả có thể chưa chính xác.</p>
      </div>

      {waiting && (
        <p role="status" className="flex items-center gap-3 text-sm">
          <span aria-hidden className="size-4 animate-spin rounded-full border-2 border-accent border-t-transparent" />
          Đang đọc công thức… thường mất vài giây.
        </p>
      )}

      {(failed || job.isError) && (
        <div role="alert" className="flex max-w-xl flex-col items-start gap-3 text-sm text-danger">
          <p>{failed ? parseErrorMessage(job.data?.errorCode ?? null) : "Không kiểm tra được tiến trình. Vui lòng thử lại."}</p>
          <Button variant="secondary" onClick={reset}>
            Thử lại
          </Button>
        </div>
      )}

      {jobId === null && (
        <ImportSourceForm
          disabled={starting}
          error={startError}
          onSubmitUrl={(url) => void start(() => startUrlImport(url))}
          onSubmitPhoto={(file) => void start(() => startImageImport(file))}
        />
      )}
    </div>
  );
}
