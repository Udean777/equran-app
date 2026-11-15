import { fireEvent, render } from "@testing-library/react-native";

import { Button } from "./button";

describe("Button", () => {
  it("calls onPress and exposes the label as accessible name", async () => {
    const onPress = jest.fn();
    const { getByRole } = await render(
      <Button label="Retry" onPress={onPress} />,
    );

    await fireEvent.press(getByRole("button", { name: "Retry" }));
    expect(onPress).toHaveBeenCalledTimes(1);
  });

  it("does not call onPress when disabled", async () => {
    const onPress = jest.fn();
    const { getByRole } = await render(
      <Button label="Retry" onPress={onPress} disabled />,
    );

    await fireEvent.press(getByRole("button", { name: "Retry" }));
    expect(onPress).not.toHaveBeenCalled();
  });
});
