import type { components } from "@/lib/api/schema";

export type GachaCase = components["schemas"]["GachaCases"]["items"][number];
export type CaseId = GachaCase["id"];
export type CaseGroup = GachaCase["group"];

export interface CaseStyle {
  name: string;
  rule: string;
  tag: string;
  color: string;
}

/** Tabs of the case picker, in order; the backend tags every case with its group. */
export const CASE_TABS: Array<{ group: CaseGroup; label: string }> = [
  { group: "featured", label: "Nổi bật" },
  { group: "cuisine", label: "Ẩm thực" },
  { group: "equipment", label: "Dụng cụ" },
  { group: "meal_type", label: "Loại món" },
  { group: "technique", label: "Cách nấu" },
  { group: "diet", label: "Chế độ ăn" },
];

/** Copy and accent of the fixed cases. Which recipes a case holds is decided by the backend (`GET /gacha/cases`). */
const FEATURED_STYLES: Record<string, CaseStyle> = {
  all: { name: "Hòm Tổng hợp", rule: "Mọi công thức của bạn", tag: "TẤT CẢ", color: "#ff8a1f" },
  quick: { name: "Hòm Nhanh gọn", rule: "Xong trong 30 phút", tag: "NHANH", color: "#6bbf59" },
  epic: { name: "Hòm Cầu kỳ", rule: "Món Sử thi và Huyền thoại", tag: "CẦU KỲ", color: "#ff3b30" },
};

/** Tag cases pick from this palette by id, so a case keeps its colour (same list and hash as mobile). */
const TAG_PALETTE = ["#ff8a1f", "#ffc233", "#3dd6c6", "#8fa3ff", "#6bbf59", "#ff6fb5", "#b98cff", "#ff3b30"];

function paletteColor(id: string): string {
  let hash = 0;
  for (const char of id) hash = (hash * 31 + char.charCodeAt(0)) % 9973;
  return TAG_PALETTE[hash % TAG_PALETTE.length]!;
}

export function caseStyle(item: Pick<GachaCase, "id" | "label">): CaseStyle {
  const featured = FEATURED_STYLES[item.id];
  if (featured) return featured;
  const label = item.label ?? item.id;
  return { name: `Hòm ${label}`, rule: `Món gắn thẻ ${label}`, tag: label.toUpperCase(), color: paletteColor(item.id) };
}

/** Same shape the backend accepts: a fixed case or `<dimension>.<tag>`. */
export const isCaseId = (value: string): boolean => /^(all|quick|epic|[a-z_]+\.[a-z0-9-]+)$/.test(value);

export const featuredCaseName = (id: string): string | undefined => FEATURED_STYLES[id]?.name;
