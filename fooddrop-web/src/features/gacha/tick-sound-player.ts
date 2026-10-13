import type { Rarity } from "../recipes/recipe-types";

// Original sounds synthesized by `scripts/generate-gacha-sounds.mjs` (no third-party audio).
const SOUND_NAMES = ["tick", "reveal-white", "reveal-blue", "reveal-purple", "reveal-pink", "reveal-red"] as const;
type SoundName = (typeof SOUND_NAMES)[number];

let context: AudioContext | null = null;
let output: GainNode | null = null;
let loading: Promise<void> | null = null;
const buffers = new Map<SoundName, AudioBuffer>();

async function loadSounds(audio: AudioContext): Promise<void> {
  await Promise.all(
    SOUND_NAMES.map(async (name) => {
      const response = await fetch(`/sounds/${name}.wav`);
      if (!response.ok) throw new Error(`Could not load ${name} (${response.status})`);
      buffers.set(name, await audio.decodeAudioData(await response.arrayBuffer()));
    }),
  );
}

/**
 * Creates the AudioContext and decodes the sounds once, so each tick is an instant `AudioBufferSourceNode`.
 * The constructor blocks the main thread while the OS opens the audio device (seconds on a faulty
 * Windows output), so this runs when the page opens, not on the spin click. Without a prior user
 * gesture the context starts suspended; `unlockReelSounds` resumes it. Never throws.
 */
export async function prepareReelSounds(): Promise<void> {
  try {
    if (!context) {
      context = new AudioContext();
      output = context.createGain();
      output.gain.value = 0.6;
      output.connect(context.destination);
    }
    loading ??= loadSounds(context).catch((error: unknown) => {
      loading = null; // Retry on the next spin.
      throw error;
    });
    await loading;
  } catch (error) {
    console.error("Reel sounds unavailable", error);
  }
}

/** Call from the spin click: browsers only start audio after a user gesture. Without audio the reel still spins. */
export async function unlockReelSounds(): Promise<void> {
  // Normally already built on mount; otherwise this builds the context synchronously, still inside the gesture.
  const ready = prepareReelSounds();
  try {
    if (context?.state === "suspended") await context.resume();
    await ready;
  } catch (error) {
    console.error("Reel sounds unavailable", error);
  }
}

function play(name: SoundName): void {
  const buffer = buffers.get(name);
  if (!context || !output || context.state !== "running" || !buffer) return;
  const source = context.createBufferSource();
  source.buffer = buffer;
  source.connect(output);
  source.start();
}

export const playTick = () => play("tick");
export const playReveal = (rarity: Rarity) => play(`reveal-${rarity}`);
