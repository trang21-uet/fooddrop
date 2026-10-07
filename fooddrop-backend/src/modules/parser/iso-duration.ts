const ISO_DURATION = /^P(?:(\d+)D)?(?:T(?:(\d+)H)?(?:(\d+)M)?(?:(\d+(?:\.\d+)?)S)?)?$/i;

/** schema.org durations ("PT1H30M", "P0DT45M", "PT90M") to whole minutes; null when unparseable or zero. */
export function isoDurationToMinutes(value: unknown): number | null {
  if (typeof value !== 'string') return null;
  const match = ISO_DURATION.exec(value.trim());
  if (!match) return null;
  const [, days, hours, minutes, seconds] = match;
  const total =
    Number(days ?? 0) * 1440 + Number(hours ?? 0) * 60 + Number(minutes ?? 0) + Math.ceil(Number(seconds ?? 0) / 60);
  return total > 0 ? total : null;
}
