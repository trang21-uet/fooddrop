import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { describe, expect, it } from "vitest";
import { addTimerMs, pauseTimer, resumeTimer, timerRemainingMs, type TimerClock } from "./timer-math";

interface Cases {
  remaining: { timer: TimerClock; now: number; expected: number }[];
  pause: { timer: TimerClock; now: number; expected: TimerClock }[];
  resume: { timer: TimerClock; now: number; expected: TimerClock }[];
  add: { timer: TimerClock; now: number; addMs: number; expected: TimerClock }[];
}

const cases = JSON.parse(readFileSync(resolve(process.cwd(), "../docs/fixtures/timer-math-cases.json"), "utf8")) as Cases;

describe("timer math (shared vectors)", () => {
  it.each(cases.remaining)("remaining at $now -> $expected", ({ timer, now, expected }) => {
    expect(timerRemainingMs(timer, now)).toBe(expected);
  });
  it.each(cases.pause)("pause at $now", ({ timer, now, expected }) => {
    expect(pauseTimer(timer, now)).toEqual(expected);
  });
  it.each(cases.resume)("resume at $now", ({ timer, now, expected }) => {
    expect(resumeTimer(timer, now)).toEqual(expected);
  });
  it.each(cases.add)("add $addMs at $now", ({ timer, now, addMs, expected }) => {
    expect(addTimerMs(timer, addMs, now)).toEqual(expected);
  });
});
