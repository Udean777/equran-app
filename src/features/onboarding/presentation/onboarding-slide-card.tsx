import {
  AlertCircle,
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
import {
  type OnboardingFeatureItem,
  type OnboardingSlide,
} from "../domain/slides";

type Props = Readonly<{
  slide: OnboardingSlide;
  direction?: 1 | -1;
  permissions: OnboardingPermissions;
  permissionRequested: boolean;
  isRequesting: boolean;
  onRequestPermissions: () => void;
}>;

const goldColor = BRAND_COLORS.gold.DEFAULT;
const mutedColor = BRAND_COLORS.onboarding.muted;

const renderFeatureIcon = (id: OnboardingFeatureItem["id"]) => {
  if (id === "quran") return <BookOpen color={goldColor} size={20} />;
  if (id === "prayer") return <Clock color={goldColor} size={20} />;
  return <Brain color={goldColor} size={20} />;
};

type PermissionRowProps = Readonly<{
  icon: React.ReactNode;
  title: string;
  description: string;
  requested: boolean;
  granted: boolean;
  grantedLabel: string;
  notGrantedLabel: string;
}>;

const PermissionRow = ({
  icon,
  title,
  description,
  requested,
  granted,
  grantedLabel,
  notGrantedLabel,
}: PermissionRowProps) => (
  <View className="flex-row items-start gap-3.5 p-4">
    <View className="mt-0.5 h-10 w-10 items-center justify-center rounded-xl border border-gold/30 bg-gold/10">
      {icon}
    </View>
    <View className="flex-1 gap-1">
      <View className="flex-row items-center justify-between gap-2">
        <Text className="text-base font-bold text-onboarding-text">
          {title}
        </Text>
        {requested ? (
          <View className="flex-row items-center gap-1">
            {granted ? (
              <CheckCircle2 color={goldColor} size={14} />
            ) : (
              <AlertCircle color={mutedColor} size={14} />
            )}
            <Text
              className={cn(
                "text-xs font-bold",
                granted ? "text-gold" : "text-onboarding-muted",
              )}
            >
              {granted ? grantedLabel : notGrantedLabel}
            </Text>
          </View>
        ) : null}
      </View>
      <Text className="text-sm leading-5 text-onboarding-muted">
        {description}
      </Text>
    </View>
  </View>
);

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
    direction >= 0 ? FadeInRight.duration(240) : FadeInLeft.duration(240);
  const exiting =
    direction >= 0 ? FadeOutLeft.duration(160) : FadeOutRight.duration(160);

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
          <View className="mb-6 h-24 w-24 items-center justify-center rounded-3xl border border-gold/50 bg-onboarding-surface">
            <Text className="font-arabic text-5xl text-gold">ق</Text>
          </View>

          <Text className="font-serif text-4xl font-bold tracking-wider text-gold">
            {t(slide.titleKey)}
          </Text>
          <Text className="mt-2 text-center text-lg font-semibold text-onboarding-text">
            {t(slide.subtitleKey)}
          </Text>
          <Text className="mt-3 max-w-xs text-center text-sm leading-6 text-onboarding-muted">
            {t(slide.descriptionKey)}
          </Text>

          <View className="mt-8 flex-row flex-wrap items-center justify-center gap-2">
            {[
              "onboarding.slides.welcome.chipQuran",
              "onboarding.slides.welcome.chipPrayer",
              "onboarding.slides.welcome.chipHafalan",
            ].map((chipKey) => (
              <View
                key={chipKey}
                className="rounded-full border border-gold/35 bg-onboarding-surface px-3.5 py-1.5"
              >
                <Text className="text-xs font-semibold text-onboarding-text">
                  {t(chipKey)}
                </Text>
              </View>
            ))}
          </View>
        </ScrollView>
      </Animated.View>
    );
  }

  if (slide.kind === "features") {
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
          <Text className="text-xs font-bold uppercase tracking-widest text-gold">
            {t(slide.subtitleKey)}
          </Text>
          <Text className="mt-1 font-serif text-3xl font-bold text-onboarding-text">
            {t(slide.titleKey)}
          </Text>
          <Text className="mt-2 text-sm leading-5 text-onboarding-muted">
            {t(slide.descriptionKey)}
          </Text>

          <View className="mt-6 overflow-hidden rounded-3xl border border-gold/30 bg-onboarding-surface">
            {slide.features.map((item, index) => (
              <View
                key={item.id}
                className={cn(
                  "flex-row items-start gap-3.5 p-4",
                  index > 0 && "border-t border-gold/15",
                )}
              >
                <View className="mt-0.5 h-10 w-10 items-center justify-center rounded-xl border border-gold/30 bg-gold/10">
                  {renderFeatureIcon(item.id)}
                </View>
                <View className="flex-1 gap-1">
                  <Text className="text-base font-bold text-onboarding-text">
                    {t(item.titleKey)}
                  </Text>
                  <Text className="text-sm leading-5 text-onboarding-muted">
                    {t(item.descriptionKey)}
                  </Text>
                </View>
              </View>
            ))}
          </View>
        </ScrollView>
      </Animated.View>
    );
  }

  if (slide.kind === "permissions") {
    const allGranted =
      permissions.locationGranted && permissions.notificationGranted;

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
          <View className="mb-4 h-12 w-12 items-center justify-center rounded-2xl border border-gold/35 bg-onboarding-surface">
            <ShieldCheck color={goldColor} size={24} />
          </View>
          <Text className="text-xs font-bold uppercase tracking-widest text-gold">
            {t(slide.subtitleKey)}
          </Text>
          <Text className="mt-1 font-serif text-3xl font-bold text-onboarding-text">
            {t(slide.titleKey)}
          </Text>
          <Text className="mt-2 text-sm leading-5 text-onboarding-muted">
            {t(slide.descriptionKey)}
          </Text>

          <View className="mt-6 overflow-hidden rounded-3xl border border-gold/30 bg-onboarding-surface">
            <PermissionRow
              icon={<MapPin color={goldColor} size={18} />}
              title={t("onboarding.permissions.locationTitle")}
              description={t("onboarding.permissions.locationDesc")}
              requested={permissionRequested}
              granted={permissions.locationGranted}
              grantedLabel={t("onboarding.permissions.granted")}
              notGrantedLabel={t("onboarding.permissions.notGranted")}
            />
            <View className="border-t border-gold/15">
              <PermissionRow
                icon={<Bell color={goldColor} size={18} />}
                title={t("onboarding.permissions.notificationTitle")}
                description={t("onboarding.permissions.notificationDesc")}
                requested={permissionRequested}
                granted={permissions.notificationGranted}
                grantedLabel={t("onboarding.permissions.granted")}
                notGrantedLabel={t("onboarding.permissions.notGranted")}
              />
            </View>
          </View>

          {permissionRequested ? (
            <View className="mt-5 flex-row items-center gap-3 rounded-2xl border border-gold/30 bg-onboarding-surface p-4">
              {allGranted ? (
                <CheckCircle2 color={goldColor} size={20} />
              ) : (
                <AlertCircle color={mutedColor} size={20} />
              )}
              <Text className="flex-1 text-sm leading-5 text-onboarding-text">
                {allGranted
                  ? t("onboarding.actions.permissionsGranted")
                  : t("onboarding.actions.permissionsPartial")}
              </Text>
            </View>
          ) : (
            <AnimatedPressable
              containerClassName="mt-5"
              accessibilityRole="button"
              accessibilityLabel={t("onboarding.actions.allowPermissions")}
              disabled={isRequesting}
              onPress={onRequestPermissions}
              className="min-h-12 min-w-11 items-center justify-center rounded-2xl bg-gold px-6 py-3"
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
        <View className="mb-5 h-16 w-16 items-center justify-center rounded-3xl border border-gold/45 bg-onboarding-surface">
          <Sparkles color={goldColor} size={28} />
        </View>
        <Text className="text-xs font-bold uppercase tracking-widest text-gold">
          {t(slide.subtitleKey)}
        </Text>
        <Text className="mt-1 font-serif text-3xl font-bold text-onboarding-text">
          {t(slide.titleKey)}
        </Text>
        <Text className="mt-2.5 max-w-xs text-center text-sm leading-6 text-onboarding-muted">
          {t(slide.descriptionKey)}
        </Text>

        <View className="mt-8 w-full items-center rounded-3xl border border-gold/35 bg-onboarding-surface p-6">
          <Text className="text-center font-arabic text-arabic-ayah text-gold">
            {t("onboarding.slides.ready.basmalahArabic")}
          </Text>
          <View className="my-3 h-px w-14 bg-gold/40" />
          <Text className="text-center text-xs leading-5 text-onboarding-muted">
            {t("onboarding.slides.ready.basmalahMeaning")}
          </Text>
        </View>
      </ScrollView>
    </Animated.View>
  );
};
