import { fireEvent, render } from "@testing-library/react-native";

import { i18next } from "@/lib/i18n";

import { type SurahSummary } from "../domain/entities";
import { SurahCard } from "./surah-card";

const AL_FATIHAH: SurahSummary = {
  number: 1,
  name: "الفاتحة",
  latin: "Al-Fatihah",
  ayatCount: 7,
  revelation: "Mekah",
};

describe("SurahCard", () => {
  beforeEach(async () => {
    await i18next.changeLanguage("id");
  });

  it("renders surah metadata and triggers onPress with surah number", async () => {
    const onPress = jest.fn();
    const { getByLabelText, getByText } = await render(
      <SurahCard surah={AL_FATIHAH} onPress={onPress} />,
    );

    expect(getByText("Al-Fatihah")).toBeTruthy();
    expect(getByText("الفاتحة")).toBeTruthy();
    expect(getByText("Mekah")).toBeTruthy();
    expect(getByText("7 ayat")).toBeTruthy();

    await fireEvent.press(getByLabelText("1. Al-Fatihah"));
    expect(onPress).toHaveBeenCalledWith(AL_FATIHAH);
  });
});
