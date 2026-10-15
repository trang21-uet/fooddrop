/** The case ("hòm") drawing from the design board, outlined in the case colour. `tag` labels the front plate. */
export function ChestIcon({ color, tag, width = 150 }: { color: string; tag?: string; width?: number }) {
  return (
    <svg
      aria-hidden
      width={width}
      height={(width * 140) / 160}
      viewBox="0 0 160 140"
      style={{ filter: `drop-shadow(0 0 12px ${color}aa)` }}
    >
      <rect x="22" y="52" width="116" height="76" rx="10" fill="#2a211e" stroke={color} strokeWidth="3" />
      <rect x="48" y="52" width="8" height="76" fill={color} opacity="0.35" />
      <rect x="104" y="52" width="8" height="76" fill={color} opacity="0.35" />
      <rect x="14" y="34" width="132" height="26" rx="9" fill="#33271f" stroke={color} strokeWidth="3" />
      <rect x="70" y="52" width="20" height="26" rx="5" fill={color} />
      <circle cx="80" cy="62" r="3.2" fill="#120e0d" />
      <rect x="78.5" y="64" width="3" height="9" fill="#120e0d" />
      {tag && (
        <>
          <rect x="38" y="96" width="84" height="22" rx="6" fill="#120e0d" stroke={color} strokeWidth="1.5" />
          {/* Long tag names are squeezed to fit the plate. */}
          <text
            x="80"
            y="111"
            textAnchor="middle"
            fontSize="12"
            fontWeight="700"
            fill={color}
            {...(tag.length > 10 ? { textLength: 76, lengthAdjust: "spacingAndGlyphs" } : {})}
          >
            {tag}
          </text>
        </>
      )}
    </svg>
  );
}
