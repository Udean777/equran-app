import { fireEvent, render } from "@testing-library/react-native";
import { View } from "react-native";
import { SegmentedTabs } from "./segmented-tabs";

type TabId = "one" | "two";

describe("SegmentedTabs", () => {
  it("marks active tab selected and calls onChange on press", async () => {
    const onChange = jest.fn();
    const { getByRole } = await render(
      <SegmentedTabs<TabId>
        value="one"
        onChange={onChange}
        options={[
          {
            value: "one",
            label: "First",
            renderIcon: () => <View testID="icon-one" />,
          },
          {
            value: "two",
            label: "Second",
            renderIcon: () => <View testID="icon-two" />,
          },
        ]}
      />,
    );

    const first = getByRole("tab", { name: "First" });
    const second = getByRole("tab", { name: "Second" });
    expect(first.props.accessibilityState).toEqual({ selected: true });
    expect(second.props.accessibilityState).toEqual({ selected: false });

    await fireEvent.press(second);
    expect(onChange).toHaveBeenCalledWith("two");
  });
});
