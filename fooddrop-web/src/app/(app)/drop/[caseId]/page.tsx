import { notFound } from "next/navigation";
import { DropView } from "@/features/gacha/drop-view";
import { CASE_STYLES, isCaseId } from "@/features/gacha/gacha-case-styles";

export async function generateMetadata({ params }: { params: Promise<{ caseId: string }> }) {
  const { caseId } = await params;
  return { title: `${isCaseId(caseId) ? CASE_STYLES[caseId].name : "Quay món"} · Food Drop` };
}

export default async function DropPage({ params }: { params: Promise<{ caseId: string }> }) {
  const { caseId } = await params;
  if (!isCaseId(caseId)) notFound();
  return <DropView caseId={caseId} />;
}
