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

  it("walks through all 6 slides, requests permissions, and marks onboarding done", async () => {
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
    expect(getByText("Grant Access")).toBeTruthy();
    expect(queryByLabelText("Next")).toBeNull();

    await fireEvent.press(getByLabelText("Allow Permissions"));

    await waitFor(() => {
      expect(getByLabelText("Next")).toBeTruthy();
    });

    await fireEvent.press(getByLabelText("Next"));
    expect(getByText("Quran & Tafsir")).toBeTruthy();

    await fireEvent.press(getByLabelText("Next"));
    expect(getByText("Prayer Times & Qibla")).toBeTruthy();

    await fireEvent.press(getByLabelText("Next"));
    expect(getByText("Hafalan & Muraja'ah")).toBeTruthy();

    await fireEvent.press(getByLabelText("Next"));
    expect(getByText("All Set!")).toBeTruthy();

    await fireEvent.press(getByLabelText("Get Started"));

    expect(getOnboardingDone()).toBe(true);
    expect(useOnboardingStore.getState().completed).toBe(true);
    expect(mockReplace).toHaveBeenCalledWith("/(tabs)");
  });

  it("allows skipping from the permission slide and persists completion", async () => {
    const { getByLabelText } = await render(<OnboardingScreen />);

    await fireEvent.press(getByLabelText("Next"));
    await fireEvent.press(getByLabelText("Skip"));

    expect(getOnboardingDone()).toBe(true);
    expect(mockReplace).toHaveBeenCalledWith("/(tabs)");
  });
});
