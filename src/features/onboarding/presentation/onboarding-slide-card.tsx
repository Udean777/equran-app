import {
  Bell,
  BookOpen,
  Brain,
  CheckCircle2,
  Clock,
  MapPin,
  ShieldCheck,
  Sparkles,
} from "lucide-react-native";
import { useTranslation } from "react-i18next";
import { Pressable, Text, View } from "react-native";

import { cn } from "@/lib/cn";
import { BRAND_COLORS } from "@/theme/palette";

import { type OnboardingPermissions } from "../data/onboarding-repository";
import { type OnboardingSlide, type OnboardingSlideId } from "../domain/slides";

type Props = Readonly<{
  slide: OnboardingSlide;
  permissions: OnboardingPermissions;
  permissionRequested: boolean;
  isRequesting: boolean;
  onRequestPermissions: () => void;
}>;

const goldColor = BRAND_COLORS.gold.DEFAULT;

const renderFeatureIcon = (id: OnboardingSlideId) => {
  if (id === "quran") return <BookOpen color={goldColor} size={28} />;
  if (id === "prayer") return <Clock color={goldColor} size={28} />;
  return <Brain color={goldColor} size={28} />;
};

export const OnboardingSlideCard = ({
  slide,
  permissions,
  permissionRequested,
  isRequesting,
  onRequestPermissions,
}: Props) => {
  const { t } = useTranslation();

  if (slide.kind === "welcome") {
    return (
      <View className="flex-1 items-center justify-center px-6">
        <View className="mb-6 h-20 w-20 items-center justify-center rounded-3xl border border-gold/30 bg-gold/15">
          <Text className="font-arabic text-3xl text-gold">ق</Text>
        </View>
        <Text className="font-serif text-4xl font-bold tracking-wide text-gold">
          {t(slide.titleKey)}
        </Text>
        <Text className="mt-2 text-center text-base font-medium text-onboarding-text">
          {t(slide.subtitleKey)}
        </Text>
        <View className="my-6 h-px w-20 bg-gold/40" />
        <Text className="text-center text-sm leading-6 text-onboarding-muted">
          {t(slide.descriptionKey)}
        </Text>
      </View>
    );
  }

  if (slide.kind === "permissions") {
    const allGranted =
      permissions.locationGranted && permissions.notificationGranted;
    const locationStatusKey = permissions.locationGranted
      ? "onboarding.permissions.granted"
      : "onboarding.permissions.notGranted";
    const notificationStatusKey = permissions.notificationGranted
      ? "onboarding.permissions.granted"
      : "onboarding.permissions.notGranted";

    return (
      <View className="flex-1 justify-center px-6">
        <View className="mb-5 h-14 w-14 items-center justify-center rounded-2xl border border-gold/30 bg-gold/15">
          <ShieldCheck color={goldColor} size={28} />
        </View>
        <Text className="font-serif text-3xl font-bold text-onboarding-text">
          {t(slide.titleKey)}
        </Text>
        <Text className="mt-1 text-base font-medium text-gold">
          {t(slide.subtitleKey)}
        </Text>
        <Text className="mt-3 text-sm leading-6 text-onboarding-muted">
          {t(slide.descriptionKey)}
        </Text>

        <View className="mt-6 gap-3">
          <View className="rounded-2xl border border-gold/20 bg-onboarding-surface p-4">
            <View className="flex-row items-center justify-between gap-3">
              <View className="flex-row items-center gap-2.5">
                <MapPin color={goldColor} size={18} />
                <Text className="text-base font-semibold text-onboarding-text">
                  {t("onboarding.permissions.locationTitle")}
                </Text>
              </View>
              {permissionRequested ? (
                <Text
                  className={cn(
                    "text-xs font-semibold",
                    permissions.locationGranted
                      ? "text-gold"
                      : "text-onboarding-muted",
                  )}
                >
                  {t(locationStatusKey)}
                </Text>
              ) : null}
            </View>
            <Text className="mt-1 text-sm leading-5 text-onboarding-muted">
              {t("onboarding.permissions.locationDesc")}
            </Text>
          </View>

          <View className="rounded-2xl border border-gold/20 bg-onboarding-surface p-4">
            <View className="flex-row items-center justify-between gap-3">
              <View className="flex-row items-center gap-2.5">
                <Bell color={goldColor} size={18} />
                <Text className="text-base font-semibold text-onboarding-text">
                  {t("onboarding.permissions.notificationTitle")}
                </Text>
              </View>
              {permissionRequested ? (
                <Text
                  className={cn(
                    "text-xs font-semibold",
                    permissions.notificationGranted
                      ? "text-gold"
                      : "text-onboarding-muted",
                  )}
                >
                  {t(notificationStatusKey)}
                </Text>
              ) : null}
            </View>
            <Text className="mt-1 text-sm leading-5 text-onboarding-muted">
              {t("onboarding.permissions.notificationDesc")}
            </Text>
          </View>
        </View>

        {permissionRequested ? (
          <View className="mt-6 flex-row items-center gap-3 rounded-2xl border border-gold/20 bg-onboarding-surface p-4">
            <CheckCircle2 color={goldColor} size={20} />
            <Text className="flex-1 text-sm leading-5 text-onboarding-text">
              {allGranted
                ? t("onboarding.actions.permissionsGranted")
                : t("onboarding.actions.permissionsPartial")}
            </Text>
          </View>
        ) : (
          <Pressable
            accessibilityRole="button"
            accessibilityLabel={t("onboarding.actions.allowPermissions")}
            disabled={isRequesting}
            onPress={onRequestPermissions}
            className="mt-6 min-h-11 min-w-11 items-center justify-center rounded-full bg-gold px-6 py-3"
          >
            <Text className="text-base font-bold text-on-gold">
              {t("onboarding.actions.allowPermissions")}
            </Text>
          </Pressable>
        )}
      </View>
    );
  }

  if (slide.kind === "ready") {
    return (
      <View className="flex-1 items-center justify-center px-6">
        <View className="mb-5 h-14 w-14 items-center justify-center rounded-2xl border border-gold/30 bg-gold/15">
          <Sparkles color={goldColor} size={28} />
        </View>
        <Text className="font-serif text-3xl font-bold text-onboarding-text">
          {t(slide.titleKey)}
        </Text>
        <Text className="mt-1 text-center text-base font-medium text-gold">
          {t(slide.subtitleKey)}
        </Text>
        <Text className="mt-3 text-center text-sm leading-6 text-onboarding-muted">
          {t(slide.descriptionKey)}
        </Text>

        <View className="mt-8 w-full rounded-2xl border border-gold/25 bg-gold/10 p-5">
          <Text className="text-center font-arabic text-2xl leading-10 text-gold">
            {t("onboarding.slides.ready.basmalahArabic")}
          </Text>
          <Text className="mt-2 text-center text-xs leading-5 text-onboarding-muted">
            {t("onboarding.slides.ready.basmalahMeaning")}
          </Text>
        </View>
      </View>
    );
  }

  return (
    <View className="flex-1 justify-center px-6">
      <View className="mb-5 h-14 w-14 items-center justify-center rounded-2xl border border-gold/30 bg-gold/15">
        {renderFeatureIcon(slide.id)}
      </View>
      <Text className="font-serif text-3xl font-bold text-onboarding-text">
        {t(slide.titleKey)}
      </Text>
      <Text className="mt-1 text-base font-medium text-gold">
        {t(slide.subtitleKey)}
      </Text>
      <Text className="mt-3 text-sm leading-6 text-onboarding-muted">
        {t(slide.descriptionKey)}
      </Text>

      <View className="mt-6 gap-3">
        {slide.pointKeys.map((pointKey) => (
          <View
            key={pointKey}
            className="flex-row items-start gap-3 rounded-2xl border border-gold/20 bg-onboarding-surface p-4"
          >
            <View className="mt-1.5 h-2 w-2 rounded-full bg-gold" />
            <Text className="flex-1 text-sm leading-5 text-onboarding-text">
              {t(pointKey)}
            </Text>
          </View>
        ))}
      </View>
    </View>
  );
};
