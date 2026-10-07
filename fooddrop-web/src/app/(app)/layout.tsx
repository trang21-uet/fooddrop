import { AppHeader } from "@/components/app-header";

export default function AppLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen bg-[radial-gradient(900px_380px_at_85%_-8%,rgb(255_138_31/0.12),transparent_60%)]">
      <AppHeader />
      <main className="mx-auto w-full max-w-7xl px-4 pt-8 pb-14 sm:px-8 sm:pt-10">{children}</main>
    </div>
  );
}
