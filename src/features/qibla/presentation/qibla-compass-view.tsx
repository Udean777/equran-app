import { Compass } from "lucide-react-native";
import { useTranslation } from "react-i18next";
import { ActivityIndicator, Text, View } from "react-native";
import Animated, { useAnimatedStyle } from "react-native-reanimated";
import { signedTurnDeg } from "@/features/qibla/domain/qibla-math";
import { QiblaCompassDial } from "@/features/qibla/presentation/qibla-compass-dial";
import { QiblaNeedle } from "@/features/qibla/presentation/qibla-needle";
import { useQiblaCompass } from "@/features/qibla/presentation/use-qibla-compass";
import { cn } from "@/lib/cn";
import { BRAND_COLORS } from "@/theme/palette";

type Props = Readonly<{
  latitude: number;
  longitude: number;
  cityLabel: string;
}>;

const goldColor = BRAND_COLORS.gold.DEFAULT;

export const QiblaCompassView = ({ latitude, longitude, cityLabel }: Props) => {
  const { t } = useTranslation();
  const {
    status,
    headingDeg,
    qiblaBearingDeg,
    offsetDeg,
    isAligned,
    dialRotation,
    needleRotation,
  } = useQiblaCompass(latitude, longitude);

  const dialStyle = useAnimatedStyle(() => ({
    transform: [{ rotate: `${dialRotation.value}deg` }],
  }));

  if (status === "unsupported") {
    return (
      <View className="mt-4 items-center rounded-3xl border border-gold/70 bg-onboarding-bg p-6">
        <View className="mb-3 h-14 w-14 items-center justify-center rounded-2xl border border-gold/70 bg-onboarding-surface">
          <Compass size={26} color={goldColor} />
        </View>
        <Text className="text-center font-serif text-xl font-bold text-onboarding-text">
          {t("qibla.unsupportedTitle")}
        </Text>
        <Text className="mt-2 text-center text-sm leading-5 text-onboarding-muted">
          {t("qibla.unsupportedBody")}
        </Text>
        <View className="mt-5 rounded-2xl bg-onboarding-surface px-5 py-3">
          <Text className="text-center text-sm font-semibold tabular-nums text-gold">
            {t("qibla.bearingValue", {
              deg: qiblaBearingDeg.toFixed(1),
              city: cityLabel,
            })}
          </Text>
        </View>
      </View>
    );
  }

  const turnDeg = signedTurnDeg(offsetDeg);
  const isInitializing = status === "initializing";
  const turnLabel =
    turnDeg >= 0
      ? t("qibla.offsetRight", { deg: Math.abs(turnDeg).toFixed(0) })
      : t("qibla.offsetLeft", { deg: Math.abs(turnDeg).toFixed(0) });
  const deviceHint = isInitializing ? t("qibla.turnDevice") : turnLabel;
  const badgeLabel = isAligned ? t("qibla.aligned") : deviceHint;
  const headingValue = isInitializing ? "—" : `${headingDeg.toFixed(0)}°`;

  return (
    <View className="mt-4 rounded-3xl border border-gold/70 bg-onboarding-bg p-5">
      <View className="flex-row items-center justify-between gap-2">
        <Text className="flex-1 font-serif text-lg font-bold text-onboarding-text">
          {cityLabel}
        </Text>
        <View className="rounded-xl bg-onboarding-surface px-3 py-1.5">
          <Text className="font-arabic text-lg text-gold">الْكَعْبَة</Text>
        </View>
      </View>

      <View className="my-6 items-center justify-center">
        {/* Fixed lubber line: the phone's forward axis. */}
        <View
          className={cn(
            "mb-2 h-2.5 w-0.5 rounded-full",
            isAligned ? "bg-gold" : "bg-onboarding-muted/60",
          )}
        />

        <View
          className={cn(
            "relative h-72 w-72 items-center justify-center rounded-full border",
            isAligned ? "border-gold" : "border-gold/70",
          )}
          accessibilityLabel={t("qibla.compassA11y", {
            bearing: qiblaBearingDeg.toFixed(0),
          })}
        >
          <Animated.View className="absolute inset-0" style={dialStyle}>
            <QiblaCompassDial qiblaBearingDeg={qiblaBearingDeg} />
          </Animated.View>

          {isInitializing ? (
            <ActivityIndicator color={goldColor} />
          ) : (
            <QiblaNeedle rotation={needleRotation} isAligned={isAligned} />
          )}
        </View>
      </View>

      <View
        className={cn(
          "mb-4 self-center rounded-full px-4 py-1.5",
          isAligned ? "bg-gold" : "bg-onboarding-surface",
        )}
      >
        <Text
          className={cn(
            "text-xs font-bold tabular-nums",
            isAligned ? "text-on-gold" : "text-onboarding-text",
          )}
        >
          {badgeLabel}
        </Text>
      </View>

      <View className="flex-row gap-3">
        <View className="flex-1 rounded-2xl bg-onboarding-surface p-3.5">
          <Text className="text-xs text-onboarding-muted">
            {t("qibla.bearingLabel")}
          </Text>
          <Text className="mt-1 text-xl font-bold tabular-nums text-gold">
            {qiblaBearingDeg.toFixed(1)}°
          </Text>
        </View>
        <View className="flex-1 rounded-2xl bg-onboarding-surface p-3.5">
          <Text className="text-xs text-onboarding-muted">
            {t("qibla.headingLabel")}
          </Text>
          <Text className="mt-1 text-xl font-bold tabular-nums text-onboarding-text">
            {headingValue}
          </Text>
        </View>
      </View>

      <Text className="mt-4 text-center text-xs leading-4 text-onboarding-muted">
        {t("qibla.calibrationHint")}
      </Text>
    </View>
  );
};
