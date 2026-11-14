import { fireEvent, render } from "@testing-library/react-native";
import { Text } from "react-native";

import { FluidTabBar, type FluidTabBarProps } from "./fluid-tab-bar";

const buildProps = (activeIndex: number): FluidTabBarProps => ({
  state: {
    index: activeIndex,
    routes: [
      { key: "quran-1", name: "index" },
      { key: "prayer-1", name: "prayer" },
    ],
  },
  descriptors: {
    "quran-1": {
      options: {
        title: "Quran",
        tabBarIcon: ({ color }) => <Text style={{ color }}>Q</Text>,
      },
    },
    "prayer-1": {
      options: {
        title: "Prayer",
        tabBarIcon: ({ color }) => <Text style={{ color }}>P</Text>,
      },
    },
  },
  emitter: {
    emit: jest.fn(() => ({ defaultPrevented: false })),
  },
  navigateToTab: jest.fn(),
  insets: { bottom: 0 },
});

describe("FluidTabBar", () => {
  it("marks active tab as selected and navigates when pressing inactive tab", async () => {
    const props = buildProps(0);
    const { getByLabelText } = await render(<FluidTabBar {...props} />);

    expect(getByLabelText("Quran").props.accessibilityState).toEqual({
      selected: true,
    });
    expect(getByLabelText("Prayer").props.accessibilityState).toEqual({
      selected: false,
    });

    await fireEvent.press(getByLabelText("Prayer"));
    expect(props.navigateToTab).toHaveBeenCalledWith("prayer-1");
  });
});
