import type { components } from "@/lib/api/schema";

export type GachaCase = components["schemas"]["GachaCases"]["items"][number];
export type CaseId = GachaCase["id"];

/** Copy and accent per case. Which recipes a case holds is decided by the backend (`GET /gacha/cases`). */
export const CASE_STYLES: Record<CaseId, { name: string; rule: string; tag: string; color: string }> = {
  all: { name: "Hòm Tổng hợp", rule: "Mọi công thức của bạn", tag: "TẤT CẢ", color: "#ff8a1f" },
  breakfast: { name: "Hòm Bữa sáng", rule: "Món gắn thẻ Bữa sáng", tag: "SÁNG", color: "#ffc233" },
  lunch: { name: "Hòm Bữa trưa", rule: "Món gắn thẻ Bữa trưa", tag: "TRƯA", color: "#3dd6c6" },
  dinner: { name: "Hòm Bữa tối", rule: "Món gắn thẻ Bữa tối", tag: "TỐI", color: "#8fa3ff" },
  quick: { name: "Hòm Nhanh gọn", rule: "Xong trong 30 phút", tag: "NHANH", color: "#6bbf59" },
  epic: { name: "Hòm Cầu kỳ", rule: "Món Sử thi và Huyền thoại", tag: "CẦU KỲ", color: "#ff3b30" },
};

export const isCaseId = (value: string): value is CaseId => value in CASE_STYLES;
