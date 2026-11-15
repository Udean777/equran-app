import { fireEvent, render } from "@testing-library/react-native";
import { ArrowLeft } from "lucide-react-native";

import { IconButton } from "./icon-button";

describe("IconButton", () => {
  it("uses its label as the accessible name", async () => {
    const onPress = jest.fn();
    const { getByRole } = await render(
      <IconButton label="Go back" onPress={onPress}>
        <ArrowLeft />
      </IconButton>,
    );

    await fireEvent.press(getByRole("button", { name: "Go back" }));
    expect(onPress).toHaveBeenCalledTimes(1);
  });

  it("is announced as disabled and does not fire when disabled", async () => {
    const onPress = jest.fn();
    const { getByRole } = await render(
      <IconButton label="Go back" onPress={onPress} disabled>
        <ArrowLeft />
      </IconButton>,
    );

    const button = getByRole("button", { name: "Go back" });
    expect(button.props.accessibilityState).toEqual({ disabled: true });

    await fireEvent.press(button);
    expect(onPress).not.toHaveBeenCalled();
  });
});
