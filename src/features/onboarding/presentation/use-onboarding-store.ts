import { create } from "zustand";

import {
  markOnboardingCompleted,
  readOnboardingCompleted,
} from "../data/onboarding-repository";

type OnboardingStore = Readonly<{
  completed: boolean;
  hydrate: () => void;
  complete: () => void;
}>;

export const useOnboardingStore = create<OnboardingStore>((set) => ({
  completed: readOnboardingCompleted(),
  hydrate: () => {
    set({ completed: readOnboardingCompleted() });
  },
  complete: () => {
    markOnboardingCompleted();
    set({ completed: true });
  },
}));
