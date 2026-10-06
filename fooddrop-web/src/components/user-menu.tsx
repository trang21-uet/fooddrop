"use client";

import { useQueryClient } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { authClient } from "@/lib/auth-client";
import { Button } from "./ui/button";

export function UserMenu() {
  const router = useRouter();
  const queryClient = useQueryClient();
  const { data: session } = authClient.useSession();

  const signOut = async () => {
    await authClient.signOut();
    // Cached recipes belong to the previous user.
    queryClient.clear();
    router.replace("/login");
    router.refresh();
  };

  return (
    <div className="flex items-center gap-3">
      {session && <span className="hidden max-w-32 truncate text-sm text-muted md:inline">{session.user.name}</span>}
      <Button variant="ghost" onClick={signOut}>
        Đăng xuất
      </Button>
    </div>
  );
}
