import { useSyncExternalStore } from "react";

const TICK_MS = 500;

let now = 0;
let stop: (() => void) | null = null;
const listeners = new Set<() => void>();

function emit(value: number) {
  now = value;
  listeners.forEach((listener) => listener());
}

/** One shared clock for every timer on screen. Uses a Web Worker, falling back to setInterval. */
function start(): () => void {
  now = Date.now();
  if (typeof Worker !== "undefined") {
    try {
      const worker = new Worker(new URL("./ticker.worker.ts", import.meta.url));
      worker.onmessage = (event: MessageEvent<number>) => emit(event.data);
      return () => worker.terminate();
    } catch (error) {
      console.error("Timer worker unavailable, using setInterval", error);
    }
  }
  const handle = setInterval(() => emit(Date.now()), TICK_MS);
  return () => clearInterval(handle);
}

function subscribe(listener: () => void): () => void {
  listeners.add(listener);
  if (listeners.size === 1) stop = start();
  return () => {
    listeners.delete(listener);
    if (listeners.size === 0) {
      stop?.();
      stop = null;
    }
  };
}

/** Epoch ms of the latest tick; 0 during SSR (timers only render after client hydration). */
export function useNow(): number {
  return useSyncExternalStore(subscribe, () => now, () => 0);
}
