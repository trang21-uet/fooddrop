// Runs off the main thread: browsers throttle main-thread timers in background tabs far harder than worker ones.
const TICK_MS = 500;

setInterval(() => {
  (self as unknown as Worker).postMessage(Date.now());
}, TICK_MS);
