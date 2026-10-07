"use client";

import { useQueryClient } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { resetGroceryStore } from "@/features/grocery/use-grocery-store";
import { resetTimerStore } from "@/features/timers/use-timer-store";
import { authClient } from "@/lib/auth-client";
import { wipeLocalData } from "@/lib/local-db";
import { Button } from "./ui/button";

/** First letter of the first and last word, e.g. "Peter Parker" → "PP". */
function getInitials(name: string) {
  const words = name.trim().split(/\s+/).filter(Boolean);
  const letters = words.length > 1 ? [words[0], words[words.length - 1]] : words.slice(0, 1);
  return letters.map((word) => word[0]!.toUpperCase()).join("");
}

export function UserMenu() {
  const router = useRouter();
  const queryClient = useQueryClient();
  const { data: session } = authClient.useSession();

  const signOut = async () => {
    await authClient.signOut();
    // Cached recipes belong to the previous user.
    queryClient.clear();
    // Same for the grocery list and timers kept in this browser.
    resetGroceryStore();
    resetTimerStore();
    await wipeLocalData().catch((error: unknown) => console.error("Could not wipe local data", error));
    router.replace("/login");
    router.refresh();
  };

  return (
    <div className="flex items-center gap-2">
      {session && (
        <span
          role="img"
          aria-label={`Tài khoản: ${session.user.name}`}
          title={session.user.name}
          className="flex size-11 items-center justify-center rounded-full border border-border bg-surface-raised text-sm font-bold text-accent"
        >
          {getInitials(session.user.name)}
        </span>
      )}
      <Button variant="ghost" onClick={signOut} className="px-3">
        Đăng xuất
      </Button>
    </div>
  );
}
