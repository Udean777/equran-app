import type { ReactNode } from "react";
import { Text } from "react-native";

import { AnimatedPressable } from "@/components/animated-pressable";
import { cn } from "@/lib/cn";

export type ButtonVariant = "primary" | "gold" | "danger" | "outline";
export type ButtonSize = "sm" | "md" | "lg" | "xl";
export type ButtonShape = "pill" | "rounded" | "soft";

type Props = Readonly<{
  label: string;
  onPress: () => void;
  variant?: ButtonVariant;
  size?: ButtonSize;
  shape?: ButtonShape;
  icon?: ReactNode;
  disabled?: boolean;
  accessibilityLabel?: string;
  containerClassName?: string;
}>;

const VARIANT_CLASS: Record<ButtonVariant, string> = {
  primary: "bg-primary",
  gold: "bg-gold",
  danger: "bg-error",
  outline: "border border-gold/40 bg-onboarding-surface",
};

const LABEL_CLASS: Record<ButtonVariant, string> = {
  primary: "font-bold text-on-primary",
  gold: "font-bold text-on-gold",
  danger: "font-bold text-on-error",
  outline: "font-semibold text-onboarding-text",
};

const SIZE_CLASS: Record<ButtonSize, string> = {
  sm: "min-h-11 gap-1.5 px-4 py-2",
  md: "min-h-11 gap-2 px-6 py-2.5",
  lg: "min-h-12 gap-2 px-5 py-3",
  xl: "min-h-14 gap-3 px-6 py-3.5",
};

const LABEL_SIZE_CLASS: Record<ButtonSize, string> = {
  sm: "text-xs",
  md: "text-sm",
  lg: "text-sm",
  xl: "text-sm",
};

const SHAPE_CLASS: Record<ButtonShape, string> = {
  pill: "rounded-full",
  rounded: "rounded-2xl",
  soft: "rounded-xl",
};

export const Button = ({
  label,
  onPress,
  variant = "primary",
  size = "md",
  shape = "pill",
  icon,
  disabled = false,
  accessibilityLabel,
  containerClassName,
}: Props) => (
  <AnimatedPressable
    containerClassName={containerClassName}
    accessibilityRole="button"
    accessibilityLabel={accessibilityLabel ?? label}
    accessibilityState={{ disabled }}
    disabled={disabled}
    onPress={onPress}
    className={cn(
      "min-w-11 flex-row items-center justify-center",
      VARIANT_CLASS[variant],
      SIZE_CLASS[size],
      SHAPE_CLASS[shape],
      disabled && "opacity-50",
    )}
  >
    {icon}
    <Text className={cn(LABEL_CLASS[variant], LABEL_SIZE_CLASS[size])}>
      {label}
    </Text>
  </AnimatedPressable>
);
