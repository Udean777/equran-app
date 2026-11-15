import type { ReactNode } from "react";

import { AnimatedPressable } from "@/components/animated-pressable";
import { cn } from "@/lib/cn";

export type IconButtonVariant = "surface" | "tonal" | "ghost" | "primary";

type Props = Readonly<{
  label: string;
  onPress: () => void;
  children: ReactNode;
  variant?: IconButtonVariant;
  disabled?: boolean;
}>;

const VARIANT_CLASS: Record<IconButtonVariant, string> = {
  surface: "h-11 w-11 rounded-2xl border border-border bg-surface",
  tonal: "h-11 w-11 rounded-xl border border-border bg-surface-variant",
  ghost: "min-h-11 min-w-11 rounded-xl",
  primary: "min-h-11 min-w-11 rounded-2xl bg-primary",
};

export const IconButton = ({
  label,
  onPress,
  children,
  variant = "surface",
  disabled = false,
}: Props) => (
  <AnimatedPressable
    accessibilityRole="button"
    accessibilityLabel={label}
    accessibilityState={{ disabled }}
    disabled={disabled}
    onPress={onPress}
    className={cn("items-center justify-center", VARIANT_CLASS[variant])}
  >
    {children}
  </AnimatedPressable>
);
