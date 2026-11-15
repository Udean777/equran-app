import { fireEvent, render } from "@testing-library/react-native";

import { SearchInput } from "./search-input";

describe("SearchInput", () => {
  it("forwards typed text and hides the clear button when empty", async () => {
    const onChangeText = jest.fn();
    const { getByLabelText, queryByLabelText } = await render(
      <SearchInput
        value=""
        onChangeText={onChangeText}
        placeholder="Search"
        clearLabel="Clear"
      />,
    );

    expect(queryByLabelText("Clear")).toBeNull();
    await fireEvent.changeText(getByLabelText("Search"), "fat");
    expect(onChangeText).toHaveBeenCalledWith("fat");
  });

  it("clears the value through the clear button", async () => {
    const onChangeText = jest.fn();
    const { getByLabelText } = await render(
      <SearchInput
        value="fat"
        onChangeText={onChangeText}
        placeholder="Search"
        clearLabel="Clear"
      />,
    );

    await fireEvent.press(getByLabelText("Clear"));
    expect(onChangeText).toHaveBeenCalledWith("");
  });
});
