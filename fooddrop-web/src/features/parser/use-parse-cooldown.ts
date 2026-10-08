"use client";

import { useCallback, useEffect, useState } from "react";
import { parseCooldownSecondsLeft, startParseCooldown } from "./parse-cooldown";

/** Seconds until the next import is allowed (0 = allowed), ticking once a second while it counts down. */
export function useParseCooldown() {
  // Read storage after mount so the server-rendered markup matches the first client render.
  const [secondsLeft, setSecondsLeft] = useState(0);
  const counting = secondsLeft > 0;

  useEffect(() => setSecondsLeft(parseCooldownSecondsLeft()), []);
  useEffect(() => {
    if (!counting) return;
    const id = window.setInterval(() => setSecondsLeft(parseCooldownSecondsLeft()), 1000);
    return () => window.clearInterval(id);
  }, [counting]);

  const start = useCallback((seconds: number) => {
    startParseCooldown(seconds);
    setSecondsLeft(parseCooldownSecondsLeft());
  }, []);

  return { secondsLeft, start };
}
