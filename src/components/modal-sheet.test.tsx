import { fireEvent, render } from "@testing-library/react-native";
import { Text } from "react-native";

import { ModalSheet } from "./modal-sheet";

describe("ModalSheet", () => {
  it("exposes the sheet title as a heading and closes through its labelled button", async () => {
    const onClose = jest.fn();
    const { getByRole, getByText } = await render(
      <ModalSheet
        visible
        title="Al-Fatihah"
        subtitle="Setoran"
        closeLabel="Close"
        onClose={onClose}
      >
        <Text>Body</Text>
      </ModalSheet>,
    );

    expect(getByRole("header", { name: "Al-Fatihah" })).toBeTruthy();
    expect(getByText("Body")).toBeTruthy();

    await fireEvent.press(getByRole("button", { name: "Close" }));
    expect(onClose).toHaveBeenCalledTimes(1);
  });
});
