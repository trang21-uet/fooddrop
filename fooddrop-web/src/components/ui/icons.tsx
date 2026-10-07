import type { SVGProps } from "react";

function Icon({ children, ...props }: SVGProps<SVGSVGElement>) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={2}
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
      width={18}
      height={18}
      {...props}
    >
      {children}
    </svg>
  );
}

export const PlusIcon = (props: SVGProps<SVGSVGElement>) => (
  <Icon strokeWidth={2.4} {...props}>
    <path d="M12 5v14M5 12h14" />
  </Icon>
);

export const SearchIcon = (props: SVGProps<SVGSVGElement>) => (
  <Icon {...props}>
    <circle cx="11" cy="11" r="7" />
    <path d="M20 20l-3.5-3.5" />
  </Icon>
);

export const ClockIcon = (props: SVGProps<SVGSVGElement>) => (
  <Icon {...props}>
    <circle cx="12" cy="12" r="9" />
    <path d="M12 7v5l3 2" />
  </Icon>
);

export const CubeIcon = (props: SVGProps<SVGSVGElement>) => (
  <Icon strokeWidth={2.2} {...props}>
    <path d="M12 3l8 4.5v9L12 21l-8-4.5v-9z" />
    <path d="M12 12l8-4.5M12 12L4 7.5M12 12v9" />
  </Icon>
);

export const BowlIcon = (props: SVGProps<SVGSVGElement>) => (
  <Icon strokeWidth={1.4} {...props}>
    <path d="M3 12h18a9 9 0 0 1-18 0z" />
    <path d="M9 7c0-1.2 1-1.2 1-2.4M13 7c0-1.2 1-1.2 1-2.4" />
  </Icon>
);
