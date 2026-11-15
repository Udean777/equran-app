import { fireEvent, render } from "@testing-library/react-native";

import { Toast } from "./toast";

describe("Toast", () => {
  it("renders message when visible and invokes onDismiss when pressed", async () => {
    const onDismiss = jest.fn();
    const { getByLabelText, getByText } = await render(
      <Toast
        visible
        message="English tafsir is not available yet."
        dismissLabel="Dismiss notification"
        onDismiss={onDismiss}
        durationMs={0}
      />,
    );

    expect(getByText("English tafsir is not available yet.")).toBeTruthy();
    await fireEvent.press(getByLabelText("Dismiss notification"));
    expect(onDismiss).toHaveBeenCalledTimes(1);
  });

  it("renders nothing when not visible", async () => {
    const { queryByText } = await render(
      <Toast
        visible={false}
        message="Hidden"
        dismissLabel="Dismiss"
        onDismiss={jest.fn()}
      />,
    );

    expect(queryByText("Hidden")).toBeNull();
  });
});
