import type { PropsWithChildren } from "react";
import { SafeAreaView } from "react-native-safe-area-context";

import { cn } from "@/lib/cn";

type Props = PropsWithChildren<{ className?: string }>;

export const Screen = ({ children, className }: Props) => (
  <SafeAreaView className={cn("flex-1 bg-bg", className)}>
    {children}
  </SafeAreaView>
);
