import { X } from "lucide-react-native";
import { useColorScheme } from "nativewind";
import type { ReactNode } from "react";
import { Modal, Text, View } from "react-native";

import { IconButton } from "@/components/icon-button";
import { getThemePalette } from "@/theme/palette";

type Props = Readonly<{
  visible: boolean;
  title: string;
  subtitle?: string;
  closeLabel: string;
  onClose: () => void;
  children: ReactNode;
}>;

export const ModalSheet = ({
  visible,
  title,
  subtitle,
  closeLabel,
  onClose,
  children,
}: Props) => {
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);

  return (
    <Modal
      visible={visible}
      animationType="slide"
      presentationStyle="pageSheet"
      onRequestClose={onClose}
    >
      <View accessibilityViewIsModal className="flex-1 bg-bg px-4 pt-4">
        <View className="mb-4 flex-row items-center justify-between border-b border-border pb-3">
          <View className="flex-1 pr-3">
            <Text
              accessibilityRole="header"
              className="font-serif text-xl font-bold text-text"
            >
              {title}
            </Text>
            {subtitle ? (
              <Text className="text-xs text-muted">{subtitle}</Text>
            ) : null}
          </View>
          <IconButton label={closeLabel} onPress={onClose}>
            <X size={18} color={palette.text} />
          </IconButton>
        </View>
        {children}
      </View>
    </Modal>
  );
};
