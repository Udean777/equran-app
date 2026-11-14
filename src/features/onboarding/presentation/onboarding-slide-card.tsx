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
import { ScrollView, Text, View } from "react-native";
import Animated, {
  FadeInLeft,
  FadeInRight,
  FadeOutLeft,
  FadeOutRight,
} from "react-native-reanimated";

import { AnimatedPressable } from "@/components/animated-pressable";
import { cn } from "@/lib/cn";
import { BRAND_COLORS } from "@/theme/palette";

import { type OnboardingPermissions } from "../data/onboarding-repository";
import { type OnboardingSlide, type OnboardingSlideId } from "../domain/slides";

type Props = Readonly<{
  slide: OnboardingSlide;
  direction?: 1 | -1;
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
  direction = 1,
  permissions,
  permissionRequested,
  isRequesting,
  onRequestPermissions,
}: Props) => {
  const { t } = useTranslation();
  const entering =
    direction >= 0 ? FadeInRight.duration(260) : FadeInLeft.duration(260);
  const exiting =
    direction >= 0 ? FadeOutLeft.duration(180) : FadeOutRight.duration(180);

  if (slide.kind === "welcome") {
    return (
      <Animated.View
        key={slide.id}
        entering={entering}
        exiting={exiting}
        className="flex-1"
      >
        <ScrollView
          className="flex-1"
          contentContainerClassName="flex-grow items-center justify-center px-6 py-4"
          showsVerticalScrollIndicator={false}
        >
          <View className="mb-7 items-center justify-center rounded-full border border-gold/20 p-4">
            <View className="items-center justify-center rounded-full border border-gold/35 p-3">
              <View className="h-20 w-20 items-center justify-center rounded-3xl border border-gold/50 bg-onboarding-surface">
                <Text className="font-arabic text-4xl text-gold">ق</Text>
              </View>
            </View>
          </View>

          <Text className="font-serif text-4xl font-bold tracking-wider text-gold">
            {t(slide.titleKey)}
          </Text>
          <Text className="mt-2 text-center text-base font-medium text-onboarding-text">
            {t(slide.subtitleKey)}
          </Text>

          <View className="my-6 flex-row items-center gap-3">
            <View className="h-px w-12 bg-gold/45" />
            <View className="h-2 w-2 rounded-full bg-gold" />
            <View className="h-px w-12 bg-gold/45" />
          </View>

          <Text className="text-center text-sm leading-6 text-onboarding-muted">
            {t(slide.descriptionKey)}
          </Text>
        </ScrollView>
      </Animated.View>
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
      <Animated.View
        key={slide.id}
        entering={entering}
        exiting={exiting}
        className="flex-1"
      >
        <ScrollView
          className="flex-1"
          contentContainerClassName="flex-grow justify-center px-6 py-4"
          showsVerticalScrollIndicator={false}
        >
          <View className="mb-4 h-16 w-16 items-center justify-center rounded-3xl border border-gold/40 bg-onboarding-surface">
            <ShieldCheck color={goldColor} size={30} />
          </View>
          <Text className="text-xs font-bold uppercase tracking-widest text-gold">
            {t(slide.subtitleKey)}
          </Text>
          <Text className="mt-1 font-serif text-2xl font-bold text-onboarding-text">
            {t(slide.titleKey)}
          </Text>
          <Text className="mt-2.5 text-sm leading-6 text-onboarding-muted">
            {t(slide.descriptionKey)}
          </Text>

          <View className="mt-6 gap-3">
            <View className="rounded-3xl border border-gold/35 bg-onboarding-surface p-4">
              <View className="flex-row items-center justify-between gap-3">
                <View className="flex-row items-center gap-3">
                  <View className="h-9 w-9 items-center justify-center rounded-xl border border-gold/30 bg-gold/15">
                    <MapPin color={goldColor} size={18} />
                  </View>
                  <Text className="text-base font-bold text-onboarding-text">
                    {t("onboarding.permissions.locationTitle")}
                  </Text>
                </View>
                {permissionRequested ? (
                  <Text
                    className={cn(
                      "text-xs font-bold",
                      permissions.locationGranted
                        ? "text-gold"
                        : "text-onboarding-muted",
                    )}
                  >
                    {t(locationStatusKey)}
                  </Text>
                ) : null}
              </View>
              <Text className="mt-2 text-sm leading-5 text-onboarding-muted">
                {t("onboarding.permissions.locationDesc")}
              </Text>
            </View>

            <View className="rounded-3xl border border-gold/35 bg-onboarding-surface p-4">
              <View className="flex-row items-center justify-between gap-3">
                <View className="flex-row items-center gap-3">
                  <View className="h-9 w-9 items-center justify-center rounded-xl border border-gold/30 bg-gold/15">
                    <Bell color={goldColor} size={18} />
                  </View>
                  <Text className="text-base font-bold text-onboarding-text">
                    {t("onboarding.permissions.notificationTitle")}
                  </Text>
                </View>
                {permissionRequested ? (
                  <Text
                    className={cn(
                      "text-xs font-bold",
                      permissions.notificationGranted
                        ? "text-gold"
                        : "text-onboarding-muted",
                    )}
                  >
                    {t(notificationStatusKey)}
                  </Text>
                ) : null}
              </View>
              <Text className="mt-2 text-sm leading-5 text-onboarding-muted">
                {t("onboarding.permissions.notificationDesc")}
              </Text>
            </View>
          </View>

          {permissionRequested ? (
            <View className="mt-6 flex-row items-center gap-3 rounded-2xl border border-gold/35 bg-onboarding-surface p-4">
              <CheckCircle2 color={goldColor} size={20} />
              <Text className="flex-1 text-sm leading-5 text-onboarding-text">
                {allGranted
                  ? t("onboarding.actions.permissionsGranted")
                  : t("onboarding.actions.permissionsPartial")}
              </Text>
            </View>
          ) : (
            <AnimatedPressable
              containerClassName="mt-6"
              accessibilityRole="button"
              accessibilityLabel={t("onboarding.actions.allowPermissions")}
              disabled={isRequesting}
              onPress={onRequestPermissions}
              className="min-h-11 min-w-11 items-center justify-center rounded-full bg-gold px-6 py-3"
            >
              <Text className="text-base font-bold text-on-gold">
                {t("onboarding.actions.allowPermissions")}
              </Text>
            </AnimatedPressable>
          )}
        </ScrollView>
      </Animated.View>
    );
  }

  if (slide.kind === "ready") {
    return (
      <Animated.View
        key={slide.id}
        entering={entering}
        exiting={exiting}
        className="flex-1"
      >
        <ScrollView
          className="flex-1"
          contentContainerClassName="flex-grow items-center justify-center px-6 py-4"
          showsVerticalScrollIndicator={false}
        >
          <View className="mb-5 items-center justify-center rounded-full border border-gold/25 p-3">
            <View className="h-16 w-16 items-center justify-center rounded-3xl border border-gold/45 bg-onboarding-surface">
              <Sparkles color={goldColor} size={28} />
            </View>
          </View>
          <Text className="text-xs font-bold uppercase tracking-widest text-gold">
            {t(slide.subtitleKey)}
          </Text>
          <Text className="mt-1 font-serif text-3xl font-bold text-onboarding-text">
            {t(slide.titleKey)}
          </Text>
          <Text className="mt-3 text-center text-sm leading-6 text-onboarding-muted">
            {t(slide.descriptionKey)}
          </Text>

          <View className="mt-8 w-full items-center rounded-3xl border border-gold/40 bg-onboarding-surface p-6">
            <Text className="text-center font-arabic text-arabic-ayah text-gold">
              {t("onboarding.slides.ready.basmalahArabic")}
            </Text>
            <View className="my-3 h-0.5 w-12 rounded-full bg-gold/50" />
            <Text className="text-center text-xs leading-5 text-onboarding-muted">
              {t("onboarding.slides.ready.basmalahMeaning")}
            </Text>
          </View>
        </ScrollView>
      </Animated.View>
    );
  }

  return (
    <Animated.View
      key={slide.id}
      entering={entering}
      exiting={exiting}
      className="flex-1"
    >
      <ScrollView
        className="flex-1"
        contentContainerClassName="flex-grow justify-center px-6 py-4"
        showsVerticalScrollIndicator={false}
      >
        <View className="mb-4 h-16 w-16 items-center justify-center rounded-3xl border border-gold/40 bg-onboarding-surface">
          {renderFeatureIcon(slide.id)}
        </View>
        <Text className="text-xs font-bold uppercase tracking-widest text-gold">
          {t(slide.subtitleKey)}
        </Text>
        <Text className="mt-1 font-serif text-2xl font-bold text-onboarding-text">
          {t(slide.titleKey)}
        </Text>
        <Text className="mt-2.5 text-sm leading-6 text-onboarding-muted">
          {t(slide.descriptionKey)}
        </Text>

        <View className="mt-6 gap-3">
          {slide.pointKeys.map((pointKey) => (
            <View
              key={pointKey}
              className="flex-row items-center gap-3.5 rounded-3xl border border-gold/35 bg-onboarding-surface p-4"
            >
              <View className="h-9 w-9 items-center justify-center rounded-xl border border-gold/30 bg-gold/15">
                <CheckCircle2 color={goldColor} size={17} />
              </View>
              <Text className="flex-1 text-sm leading-5 text-onboarding-text">
                {t(pointKey)}
              </Text>
            </View>
          ))}
        </View>
      </ScrollView>
    </Animated.View>
  );
};
