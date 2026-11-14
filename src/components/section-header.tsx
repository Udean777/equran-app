import { Text, View } from "react-native";

type Props = Readonly<{
  title: string;
  trailingText?: string;
}>;

export const SectionHeader = ({ title, trailingText }: Props) => (
  <View className="mb-2.5 mt-4 flex-row items-center justify-between">
    <View className="flex-row items-center gap-2.5">
      <View className="h-4 w-1 rounded-full bg-gold" />
      <Text className="font-serif text-base font-bold text-text">{title}</Text>
    </View>
    {trailingText ? (
      <View className="rounded-full border border-border bg-surface-variant px-2.5 py-0.5">
        <Text className="text-xs font-semibold text-muted">{trailingText}</Text>
      </View>
    ) : null}
  </View>
);
