import { fireEvent, render, waitFor } from "@testing-library/react-native";
import * as Location from "expo-location";
import * as Notifications from "expo-notifications";

import { i18next } from "@/lib/i18n";
import { clearAllPrefs, getOnboardingDone } from "@/lib/storage/prefs";

import { OnboardingScreen } from "./onboarding-screen";
import { useOnboardingStore } from "./use-onboarding-store";

const mockReplace = jest.fn();

jest.mock("expo-router", () => ({
  useRouter: () => ({
    replace: mockReplace,
  }),
}));

jest.mock("expo-location", () => ({
  requestForegroundPermissionsAsync: jest.fn(),
}));

jest.mock("expo-notifications", () => ({
  requestPermissionsAsync: jest.fn(),
  IosAuthorizationStatus: {
    PROVISIONAL: 3,
  },
}));

describe("OnboardingScreen", () => {
  beforeEach(async () => {
    jest.clearAllMocks();
    clearAllPrefs();
    useOnboardingStore.getState().hydrate();
    await i18next.changeLanguage("en");
  });

  it("walks through all 4 slides, requests permissions, and marks onboarding done", async () => {
    (Location.requestForegroundPermissionsAsync as jest.Mock).mockResolvedValue(
      {
        granted: true,
      },
    );
    (Notifications.requestPermissionsAsync as jest.Mock).mockResolvedValue({
      granted: true,
    });

    const { getByLabelText, getByText, queryByLabelText } = await render(
      <OnboardingScreen />,
    );

    expect(getByText("Qurva")).toBeTruthy();

    await fireEvent.press(getByLabelText("Next"));
    expect(getByText("Focused & Offline-First")).toBeTruthy();

    await fireEvent.press(getByLabelText("Next"));
    expect(getByText("Grant Access")).toBeTruthy();
    expect(queryByLabelText("Next")).toBeNull();

    await fireEvent.press(getByLabelText("Allow Permissions"));

    await waitFor(() => {
      expect(getByLabelText("Next")).toBeTruthy();
    });

    await fireEvent.press(getByLabelText("Next"));
    expect(getByText("All Set!")).toBeTruthy();

    await fireEvent.press(getByLabelText("Get Started"));

    expect(getOnboardingDone()).toBe(true);
    expect(useOnboardingStore.getState().completed).toBe(true);
    expect(mockReplace).toHaveBeenCalledWith("/(tabs)");
  });

  it("allows skipping from the top bar and persists completion", async () => {
    const { getAllByLabelText } = await render(<OnboardingScreen />);

    const skipButtons = getAllByLabelText("Skip");
    const firstSkip = skipButtons[0];
    if (!firstSkip) throw new Error("Expected Skip button");
    await fireEvent.press(firstSkip);

    expect(getOnboardingDone()).toBe(true);
    expect(mockReplace).toHaveBeenCalledWith("/(tabs)");
  });
});
