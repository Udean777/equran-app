import { useTranslation } from "react-i18next";
import { Text } from "react-native";

import { Screen } from "@/components/screen";

type Props = { messageKey: string };

export const PlaceholderScreen = ({ messageKey }: Props) => {
  const { t } = useTranslation();

  return (
    <Screen
      edges={["top", "left", "right"]}
      className="items-center justify-center"
    >
      <Text className="text-base text-text">{t(messageKey)}</Text>
    </Screen>
  );
};
