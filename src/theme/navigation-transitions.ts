export const STACK_TRANSITIONS = {
  push: {
    animation: "slide_from_right",
    animationDuration: 260,
  },
  fade: {
    animation: "fade",
    animationDuration: 220,
  },
  modal: {
    animation: "slide_from_bottom",
    animationDuration: 260,
  },
} as const;

export const TAB_TRANSITIONS = {
  shift: {
    animation: "shift",
  },
  fade: {
    animation: "fade",
  },
} as const;
