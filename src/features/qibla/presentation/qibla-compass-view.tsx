import { Compass, Navigation } from "lucide-react-native";
import { useTranslation } from "react-i18next";
import { Text, View } from "react-native";
import { useQiblaCompass } from "@/features/qibla/presentation/use-qibla-compass";
import { cn } from "@/lib/cn";
import { BRAND_COLORS } from "@/theme/palette";

type Props = Readonly<{
  latitude: number;
  longitude: number;
  cityLabel: string;
}>;

const DIAL_TICKS = Array.from({ length: 24 }, (_, idx) => idx * 15);
const goldColor = BRAND_COLORS.gold.DEFAULT;
const goldLightColor = BRAND_COLORS.gold.light;

export const QiblaCompassView = ({ latitude, longitude, cityLabel }: Props) => {
  const { t } = useTranslation();
  const { status, headingDeg, qiblaBearingDeg, offsetDeg, isAligned } =
    useQiblaCompass(latitude, longitude);

  if (status === "unsupported") {
    return (
      <View className="mt-4 items-center rounded-3xl border border-gold/40 bg-onboarding-bg p-6">
        <View className="mb-3 h-14 w-14 items-center justify-center rounded-2xl border border-gold/30 bg-onboarding-surface">
          <Compass size={26} color={goldColor} />
        </View>
        <Text className="text-center font-serif text-xl font-bold text-onboarding-text">
          {t("qibla.unsupportedTitle")}
        </Text>
        <Text className="mt-2 text-center text-sm leading-5 text-onboarding-muted">
          {t("qibla.unsupportedBody")}
        </Text>
        <View className="mt-5 rounded-2xl border border-gold/35 bg-onboarding-surface px-5 py-3">
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

  return (
    <View className="mt-4 overflow-hidden rounded-3xl border border-gold/40 bg-onboarding-bg p-5">
      <View className="flex-row items-center justify-between gap-2">
        <View>
          <Text className="font-serif text-lg font-bold text-onboarding-text">
            {cityLabel}
          </Text>
          <Text className="text-xs text-onboarding-muted">
            {t("qibla.bearingValue", {
              deg: qiblaBearingDeg.toFixed(1),
              city: cityLabel,
            })}
          </Text>
        </View>
        <View className="rounded-xl border border-gold/35 bg-onboarding-surface px-3 py-1.5">
          <Text className="font-arabic text-lg text-gold">الْكَعْبَة</Text>
        </View>
      </View>

      <View className="my-5 items-center justify-center">
        {/* Fixed top reference notch indicating phone's forward axis */}
        <View
          className={cn(
            "mb-2 h-2.5 w-0.5 rounded-full",
            isAligned ? "bg-gold" : "bg-onboarding-muted/50",
          )}
        />

        <View
          className={cn(
            "relative h-72 w-72 items-center justify-center rounded-full border-2 bg-onboarding-surface",
            isAligned ? "border-gold" : "border-gold/35",
          )}
          accessibilityLabel={t("qibla.compassA11y", {
            bearing: qiblaBearingDeg.toFixed(0),
          })}
        >
          {/* Inner decorative ring */}
          <View className="absolute h-56 w-56 rounded-full border border-gold/20" />

          {/* Rotating degree ticks and cardinal markers */}
          <View
            className="absolute inset-0 items-center justify-center"
            style={{ transform: [{ rotate: `${-headingDeg}deg` }] }}
          >
            {DIAL_TICKS.map((deg) => {
              const isCardinal = deg % 90 === 0;
              return (
                <View
                  key={deg}
                  className="absolute inset-0 items-center"
                  style={{ transform: [{ rotate: `${deg}deg` }] }}
                >
                  <View
                    className={cn(
                      "mt-1.5 rounded-full",
                      isCardinal
                        ? "h-2.5 w-0.5 bg-gold"
                        : "h-1.5 w-px bg-onboarding-muted/35",
                    )}
                  />
                </View>
              );
            })}

            <Text className="absolute top-5 text-xs font-bold tracking-wider text-gold">
              N
            </Text>
            <Text className="absolute right-5 text-xs font-semibold text-onboarding-muted">
              E
            </Text>
            <Text className="absolute bottom-5 text-xs font-semibold text-onboarding-muted">
              S
            </Text>
            <Text className="absolute left-5 text-xs font-semibold text-onboarding-muted">
              W
            </Text>
          </View>

          {/* Qibla direction needle relative to phone's top axis */}
          <View
            className="h-44 w-44 items-center justify-center"
            style={{ transform: [{ rotate: `${offsetDeg}deg` }] }}
          >
            <View className="-mt-20 items-center">
              <Navigation
                size={34}
                color={isAligned ? goldLightColor : goldColor}
                fill={isAligned ? goldLightColor : goldColor}
              />
            </View>
          </View>

          <View
            className={cn(
              "absolute h-3.5 w-3.5 rounded-full border-2 border-onboarding-bg",
              isAligned ? "bg-gold" : "bg-onboarding-muted",
            )}
          />
        </View>
      </View>

      <View
        className={cn(
          "mb-4 self-center rounded-full px-4 py-1.5",
          isAligned ? "bg-gold" : "border border-gold/30 bg-onboarding-surface",
        )}
      >
        <Text
          className={cn(
            "text-xs font-bold",
            isAligned ? "text-on-gold" : "text-onboarding-text",
          )}
        >
          {isAligned ? t("qibla.aligned") : t("qibla.turnDevice")}
        </Text>
      </View>

      <View className="flex-row gap-3">
        <View className="flex-1 rounded-2xl border border-gold/25 bg-onboarding-surface p-3.5">
          <Text className="text-xs text-onboarding-muted">
            {t("qibla.bearingLabel")}
          </Text>
          <Text className="mt-1 text-xl font-bold tabular-nums text-gold">
            {qiblaBearingDeg.toFixed(1)}°
          </Text>
        </View>
        <View className="flex-1 rounded-2xl border border-gold/25 bg-onboarding-surface p-3.5">
          <Text className="text-xs text-onboarding-muted">
            {t("qibla.headingLabel")}
          </Text>
          <Text className="mt-1 text-xl font-bold tabular-nums text-onboarding-text">
            {headingDeg.toFixed(0)}°
          </Text>
        </View>
      </View>

      <Text className="mt-4 text-center text-xs leading-4 text-onboarding-muted">
        {t("qibla.calibrationHint")}
      </Text>
    </View>
  );
};
