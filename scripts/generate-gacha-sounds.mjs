#!/usr/bin/env node
// Synthesizes the Food Drop reel sounds (original, no samples) into both clients:
//   fooddrop-web/public/sounds/  and  fooddrop-mobile/assets/sounds/
// Run from the repo root: `node scripts/generate-gacha-sounds.mjs`. Output is deterministic.
import { mkdirSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const SAMPLE_RATE = 22_050;
const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const targets = [join(root, 'fooddrop-web/public/sounds'), join(root, 'fooddrop-mobile/assets/sounds')];

/** 16-bit mono PCM WAV. */
function encodeWav(samples) {
  const buffer = Buffer.alloc(44 + samples.length * 2);
  buffer.write('RIFF', 0);
  buffer.writeUInt32LE(36 + samples.length * 2, 4);
  buffer.write('WAVEfmt ', 8);
  buffer.writeUInt32LE(16, 16);
  buffer.writeUInt16LE(1, 20); // PCM
  buffer.writeUInt16LE(1, 22); // mono
  buffer.writeUInt32LE(SAMPLE_RATE, 24);
  buffer.writeUInt32LE(SAMPLE_RATE * 2, 28);
  buffer.writeUInt16LE(2, 32);
  buffer.writeUInt16LE(16, 34);
  buffer.write('data', 36);
  buffer.writeUInt32LE(samples.length * 2, 40);
  samples.forEach((value, i) => buffer.writeInt16LE(Math.round(Math.max(-1, Math.min(1, value)) * 32_767), 44 + i * 2));
  return buffer;
}

// Seeded noise so regenerating gives byte-identical files.
let seed = 0x9e3779b9;
const noise = () => {
  seed = (seed * 1_664_525 + 1_013_904_223) >>> 0;
  return seed / 2 ** 31 - 1;
};

const buffer = (seconds) => new Float32Array(Math.ceil(seconds * SAMPLE_RATE));

/** Adds a decaying bell-like tone (fundamental + soft octave) starting at `start` seconds. */
function addTone(out, { start, frequency, duration, gain, decay = 6 }) {
  const from = Math.floor(start * SAMPLE_RATE);
  const length = Math.min(Math.floor(duration * SAMPLE_RATE), out.length - from);
  for (let i = 0; i < length; i++) {
    const t = i / SAMPLE_RATE;
    const attack = Math.min(1, t / 0.004);
    const envelope = attack * Math.exp(-decay * t);
    const phase = 2 * Math.PI * frequency * t;
    out[from + i] += gain * envelope * (Math.sin(phase) + 0.3 * Math.sin(2 * phase) + 0.12 * Math.sin(3.01 * phase));
  }
}

/** A short wooden click: a high-passed noise burst over a quick 2.4 kHz ping, about 25 ms. */
function tick() {
  const out = buffer(0.028);
  let previous = 0;
  for (let i = 0; i < out.length; i++) {
    const t = i / SAMPLE_RATE;
    const white = noise();
    const highPassed = white - previous;
    previous = white;
    out[i] = 0.35 * highPassed * Math.exp(-t / 0.0025) + 0.55 * Math.sin(2 * Math.PI * 2400 * t) * Math.exp(-t / 0.006);
  }
  return out;
}

/** Rising arpeggio in C major; rarer tiers get more notes, a low hit and a sparkle tail. */
function reveal(level) {
  const notes = [523.25, 659.25, 783.99, 1046.5, 1318.51].slice(0, level + 1);
  const step = 0.075;
  const out = buffer(0.5 + notes.length * step + level * 0.15);
  notes.forEach((frequency, i) => addTone(out, { start: i * step, frequency, duration: out.length / SAMPLE_RATE, gain: 0.32, decay: 5 - level * 0.6 }));
  if (level >= 3) addTone(out, { start: 0, frequency: 98, duration: 0.6, gain: 0.5, decay: 7 }); // low hit
  if (level >= 2) {
    // Sparkle: short high pings after the chord lands.
    const sparkles = level * 3;
    for (let i = 0; i < sparkles; i++) {
      addTone(out, { start: notes.length * step + i * 0.045, frequency: 2093 + (noise() + 1) * 900, duration: 0.12, gain: 0.07, decay: 30 });
    }
  }
  const peak = out.reduce((max, value) => Math.max(max, Math.abs(value)), 0);
  return out.map((value) => (value / peak) * 0.8);
}

const files = {
  'tick.wav': tick(),
  ...Object.fromEntries(['white', 'blue', 'purple', 'pink', 'red'].map((rarity, level) => [`reveal-${rarity}.wav`, reveal(level)])),
};

for (const dir of targets) {
  mkdirSync(dir, { recursive: true });
  for (const [name, samples] of Object.entries(files)) writeFileSync(join(dir, name), encodeWav(samples));
}
console.log(`Wrote ${Object.keys(files).join(', ')} to:\n  ${targets.join('\n  ')}`);
