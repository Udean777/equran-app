import Animated, {
  useAnimatedStyle,
  type SharedValue,
} from "react-native-reanimated";
import Svg, { Circle, Path } from "react-native-svg";
import { BRAND_COLORS } from "@/theme/palette";

type Props = Readonly<{
  rotation: SharedValue<number>;
  isAligned: boolean;
}>;

const gold = BRAND_COLORS.gold.DEFAULT;
const muted = BRAND_COLORS.onboarding.muted;

/**
 * 0 degrees points up, so the rotation value maps straight to the device heading.
 * Tip = qibla bearing, tail = opposite direction, hub covers the joint.
 */
export const QiblaNeedle = ({ rotation, isAligned }: Props) => {
  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{ rotate: `${rotation.value}deg` }],
  }));
  const tipFill = isAligned ? BRAND_COLORS.gold.light : gold;

  return (
    <Animated.View
      pointerEvents="none"
      className="absolute inset-0"
      style={animatedStyle}
    >
      <Svg width="100%" height="100%" viewBox="0 0 200 200">
        <Path d="M100 34 L93 78 L107 78 Z" fill={tipFill} />
        <Path d="M100 166 L94 122 L106 122 Z" fill={muted} fillOpacity={0.7} />
        <Circle
          cx={100}
          cy={100}
          r={7.5}
          fill={BRAND_COLORS.onboarding.bg}
          stroke={gold}
          strokeWidth={1.5}
        />
        <Circle cx={100} cy={100} r={2.5} fill={tipFill} />
      </Svg>
    </Animated.View>
  );
};
