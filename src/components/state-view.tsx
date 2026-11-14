import { useColorScheme } from "nativewind";
import { useTranslation } from "react-i18next";
import { ActivityIndicator, Text, View } from "react-native";

import { AnimatedPressable } from "@/components/animated-pressable";

import { type AppErrorCode } from "@/lib/result";
import { getThemePalette } from "@/theme/palette";

type LoadingProps = Readonly<{
  kind: "loading";
}>;

type EmptyProps = Readonly<{
  kind: "empty";
  message?: string;
}>;

type ErrorProps = Readonly<{
  kind: "error";
  errorCode: AppErrorCode;
  onRetry?: () => void;
}>;

type Props = LoadingProps | EmptyProps | ErrorProps;

const ERROR_KEY_BY_CODE: Record<AppErrorCode, string> = {
  network: "errors.network",
  timeout: "errors.timeout",
  parse: "errors.parse",
  notFound: "errors.notFound",
  permission: "errors.permission",
  server: "errors.server",
  unknown: "errors.unknown",
};

export const StateView = (props: Props) => {
  const { t } = useTranslation();
  const { colorScheme } = useColorScheme();
  const palette = getThemePalette(colorScheme);

  if (props.kind === "loading") {
    return (
      <View className="flex-1 items-center justify-center gap-3 px-6">
        <ActivityIndicator color={palette.primary} size="large" />
        <Text className="text-sm text-muted">{t("common.loading")}</Text>
      </View>
    );
  }

  if (props.kind === "empty") {
    return (
      <View className="flex-1 items-center justify-center px-6">
        <Text className="text-center text-sm text-muted">
          {props.message ?? t("common.empty")}
        </Text>
      </View>
    );
  }

  return (
    <View className="flex-1 items-center justify-center gap-4 px-6">
      <Text className="text-center text-sm leading-5 text-muted">
        {t(ERROR_KEY_BY_CODE[props.errorCode])}
      </Text>
      {props.onRetry ? (
        <AnimatedPressable
          accessibilityRole="button"
          accessibilityLabel={t("common.retry")}
          onPress={props.onRetry}
          className="min-h-11 min-w-11 items-center justify-center rounded-full bg-primary px-6 py-2.5"
        >
          <Text className="text-sm font-semibold text-on-primary">
            {t("common.retry")}
          </Text>
        </AnimatedPressable>
      ) : null}
    </View>
  );
};
