import { Search, X } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import { Pressable, TextInput, View } from "react-native";

import { cn } from "@/lib/cn";
import { getThemePalette } from "@/theme/palette";

type Props = Readonly<{
  value: string;
  onChangeText: (value: string) => void;
  placeholder: string;
  clearLabel: string;
  className?: string;
}>;

export const SearchInput = ({
  value,
  onChangeText,
  placeholder,
  clearLabel,
  className,
}: Props) => {
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);

  return (
    <View
      className={cn(
        "min-h-11 flex-row items-center gap-2.5 rounded-2xl border border-border bg-surface px-3.5",
        className,
      )}
    >
      <View
        accessibilityElementsHidden
        importantForAccessibility="no-hide-descendants"
      >
        <Search color={palette.primary} size={17} />
      </View>
      <TextInput
        accessibilityLabel={placeholder}
        placeholder={placeholder}
        placeholderTextColor={palette.muted}
        returnKeyType="search"
        autoCorrect={false}
        value={value}
        onChangeText={onChangeText}
        className="flex-1 py-2 text-sm text-text"
      />
      {value.length > 0 ? (
        <Pressable
          accessibilityRole="button"
          accessibilityLabel={clearLabel}
          hitSlop={8}
          onPress={() => onChangeText("")}
          className="min-h-11 min-w-11 items-center justify-center"
        >
          <X color={palette.muted} size={16} />
        </Pressable>
      ) : null}
    </View>
  );
};
