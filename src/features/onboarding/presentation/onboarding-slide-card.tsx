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
import colors from "@/theme/colors.json";

import { type OnboardingPermissions } from "../data/onboarding-repository";
import { type OnboardingSlide, type OnboardingSlideId } from "../domain/slides";

type Props = Readonly<{
  slide: OnboardingSlide;
  permissions: OnboardingPermissions;
  permissionRequested: boolean;
  isRequesting: boolean;
  onRequestPermissions: () => void;
}>;

const renderFeatureIcon = (id: OnboardingSlideId) => {
  if (id === "quran") return <BookOpen color={colors.primary} size={28} />;
  if (id === "prayer") return <Clock color={colors.primary} size={28} />;
  return <Brain color={colors.primary} size={28} />;
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
        <View className="mb-6 h-20 w-20 items-center justify-center rounded-3xl border border-border bg-surface">
          <Text className="font-arabic text-3xl text-primary">ق</Text>
        </View>
        <Text className="font-serif text-4xl font-bold tracking-wide text-primary">
          {t(slide.titleKey)}
        </Text>
        <Text className="mt-2 text-center text-base font-medium text-text">
          {t(slide.subtitleKey)}
        </Text>
        <View className="my-6 h-px w-20 bg-border" />
        <Text className="text-center text-sm leading-6 text-muted">
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
        <View className="mb-5 h-14 w-14 items-center justify-center rounded-2xl border border-border bg-surface">
          <ShieldCheck color={colors.primary} size={28} />
        </View>
        <Text className="font-serif text-3xl font-bold text-text">
          {t(slide.titleKey)}
        </Text>
        <Text className="mt-1 text-base font-medium text-primary">
          {t(slide.subtitleKey)}
        </Text>
        <Text className="mt-3 text-sm leading-6 text-muted">
          {t(slide.descriptionKey)}
        </Text>

        <View className="mt-6 gap-3">
          <View className="rounded-2xl border border-border bg-surface p-4">
            <View className="flex-row items-center justify-between gap-3">
              <View className="flex-row items-center gap-2.5">
                <MapPin color={colors.primary} size={18} />
                <Text className="text-base font-semibold text-text">
                  {t("onboarding.permissions.locationTitle")}
                </Text>
              </View>
              {permissionRequested ? (
                <Text
                  className={cn(
                    "text-xs font-semibold",
                    permissions.locationGranted ? "text-primary" : "text-muted",
                  )}
                >
                  {t(locationStatusKey)}
                </Text>
              ) : null}
            </View>
            <Text className="mt-1 text-sm leading-5 text-muted">
              {t("onboarding.permissions.locationDesc")}
            </Text>
          </View>

          <View className="rounded-2xl border border-border bg-surface p-4">
            <View className="flex-row items-center justify-between gap-3">
              <View className="flex-row items-center gap-2.5">
                <Bell color={colors.primary} size={18} />
                <Text className="text-base font-semibold text-text">
                  {t("onboarding.permissions.notificationTitle")}
                </Text>
              </View>
              {permissionRequested ? (
                <Text
                  className={cn(
                    "text-xs font-semibold",
                    permissions.notificationGranted
                      ? "text-primary"
                      : "text-muted",
                  )}
                >
                  {t(notificationStatusKey)}
                </Text>
              ) : null}
            </View>
            <Text className="mt-1 text-sm leading-5 text-muted">
              {t("onboarding.permissions.notificationDesc")}
            </Text>
          </View>
        </View>

        {permissionRequested ? (
          <View className="mt-6 flex-row items-center gap-3 rounded-2xl border border-border bg-surface p-4">
            <CheckCircle2 color={colors.primary} size={20} />
            <Text className="flex-1 text-sm leading-5 text-text">
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
            className="mt-6 min-h-11 min-w-11 items-center justify-center rounded-full bg-primary px-6 py-3"
          >
            <Text className="text-base font-semibold text-on-primary">
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
        <View className="mb-5 h-14 w-14 items-center justify-center rounded-2xl border border-border bg-surface">
          <Sparkles color={colors.primary} size={28} />
        </View>
        <Text className="font-serif text-3xl font-bold text-text">
          {t(slide.titleKey)}
        </Text>
        <Text className="mt-1 text-center text-base font-medium text-primary">
          {t(slide.subtitleKey)}
        </Text>
        <Text className="mt-3 text-center text-sm leading-6 text-muted">
          {t(slide.descriptionKey)}
        </Text>

        <View className="mt-8 w-full rounded-2xl border border-border bg-surface p-5">
          <Text className="text-center font-arabic text-2xl leading-10 text-primary">
            {t("onboarding.slides.ready.basmalahArabic")}
          </Text>
          <Text className="mt-2 text-center text-xs leading-5 text-muted">
            {t("onboarding.slides.ready.basmalahMeaning")}
          </Text>
        </View>
      </View>
    );
  }

  return (
    <View className="flex-1 justify-center px-6">
      <View className="mb-5 h-14 w-14 items-center justify-center rounded-2xl border border-border bg-surface">
        {renderFeatureIcon(slide.id)}
      </View>
      <Text className="font-serif text-3xl font-bold text-text">
        {t(slide.titleKey)}
      </Text>
      <Text className="mt-1 text-base font-medium text-primary">
        {t(slide.subtitleKey)}
      </Text>
      <Text className="mt-3 text-sm leading-6 text-muted">
        {t(slide.descriptionKey)}
      </Text>

      <View className="mt-6 gap-3">
        {slide.pointKeys.map((pointKey) => (
          <View
            key={pointKey}
            className="flex-row items-start gap-3 rounded-2xl border border-border bg-surface p-4"
          >
            <View className="mt-1.5 h-2 w-2 rounded-full bg-primary" />
            <Text className="flex-1 text-sm leading-5 text-text">
              {t(pointKey)}
            </Text>
          </View>
        ))}
      </View>
    </View>
  );
};
