import Image from "next/image";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center gap-6 p-8">
      <Image src="/icon-192.png" alt="Food Drop logo" width={96} height={96} priority />
      <h1 className="text-4xl font-bold tracking-tight">Food Drop</h1>
      <p className="max-w-md text-center text-foreground/70">
        Open a case, get a dish, start cooking.
      </p>
    </main>
  );
}
