import type { PropsWithChildren } from "react";
import { type Edge, SafeAreaView } from "react-native-safe-area-context";

import { cn } from "@/lib/cn";

type Props = PropsWithChildren<{
  className?: string;
  edges?: readonly Edge[];
}>;

export const Screen = ({ children, className, edges }: Props) => (
  <SafeAreaView edges={edges} className={cn("flex-1 bg-bg", className)}>
    {children}
  </SafeAreaView>
);
