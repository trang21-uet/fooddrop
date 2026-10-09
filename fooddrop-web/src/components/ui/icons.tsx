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

export const ChevronLeftIcon = (props: SVGProps<SVGSVGElement>) => (
  <Icon strokeWidth={2.2} {...props}>
    <path d="M15 6l-6 6 6 6" />
  </Icon>
);

export const ChevronUpIcon = (props: SVGProps<SVGSVGElement>) => (
  <Icon strokeWidth={2.2} {...props}>
    <path d="M6 15l6-6 6 6" />
  </Icon>
);

export const ChevronDownIcon = (props: SVGProps<SVGSVGElement>) => (
  <Icon strokeWidth={2.2} {...props}>
    <path d="M6 9l6 6 6-6" />
  </Icon>
);

export const TrashIcon = (props: SVGProps<SVGSVGElement>) => (
  <Icon {...props}>
    <path d="M4 7h16M10 11v6M14 11v6M6 7l1 12h10l1-12M9 7V4h6v3" />
  </Icon>
);

export const CloseIcon = (props: SVGProps<SVGSVGElement>) => (
  <Icon strokeWidth={2.6} {...props}>
    <path d="M6 6l12 12M18 6L6 18" />
  </Icon>
);

export const ImageIcon = (props: SVGProps<SVGSVGElement>) => (
  <Icon strokeWidth={1.6} {...props}>
    <rect x="3" y="4" width="18" height="16" rx="3" />
    <circle cx="9" cy="10" r="1.8" />
    <path d="M21 16l-5-5-8 9" />
  </Icon>
);

export const StopwatchIcon = (props: SVGProps<SVGSVGElement>) => (
  <Icon {...props}>
    <circle cx="12" cy="13" r="8" />
    <path d="M12 9v4l2.5 1.5M9 2h6" />
  </Icon>
);

export const InfoIcon = (props: SVGProps<SVGSVGElement>) => (
  <Icon {...props}>
    <circle cx="12" cy="12" r="9" />
    <path d="M12 11v5M12 8h.01" />
  </Icon>
);
