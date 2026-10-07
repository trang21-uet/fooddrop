let audioContext: AudioContext | null = null;

/**
 * Call from a click handler. Browsers only allow sound after a user gesture and only prompt for
 * notifications from one, so this is done when the user starts a timer.
 */
export async function primeTimerAlerts(): Promise<void> {
  try {
    audioContext ??= new AudioContext();
    if (audioContext.state === "suspended") await audioContext.resume();
  } catch (error) {
    console.error("Audio unavailable for timer alerts", error);
  }
  if (typeof Notification !== "undefined" && Notification.permission === "default") {
    try {
      await Notification.requestPermission();
    } catch (error) {
      console.error("Notification permission request failed", error);
    }
  }
}

/** Three short original beeps (synthesized, no audio asset). */
function playChime() {
  if (!audioContext || audioContext.state !== "running") return;
  const context = audioContext;
  for (let i = 0; i < 3; i++) {
    const start = context.currentTime + i * 0.35;
    const oscillator = context.createOscillator();
    const gain = context.createGain();
    oscillator.type = "sine";
    oscillator.frequency.value = 880;
    gain.gain.setValueAtTime(0.0001, start);
    gain.gain.exponentialRampToValueAtTime(0.4, start + 0.02);
    gain.gain.exponentialRampToValueAtTime(0.0001, start + 0.25);
    oscillator.connect(gain).connect(context.destination);
    oscillator.start(start);
    oscillator.stop(start + 0.3);
  }
}

/** Sound + vibration + a system notification (shown when the tab is in the background). */
export function alertTimerDone(label: string): void {
  playChime();
  navigator.vibrate?.([200, 100, 200]);
  if (typeof Notification !== "undefined" && Notification.permission === "granted") {
    try {
      new Notification("Hết giờ!", { body: label, tag: `timer-${label}` });
    } catch (error) {
      console.error("Could not show timer notification", error);
    }
  }
}
