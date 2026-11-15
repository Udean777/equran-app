import { memo } from "react";
import Svg, { Circle, G, Line, Rect, Text as SvgText } from "react-native-svg";
import { BRAND_COLORS } from "@/theme/palette";

type Props = Readonly<{
  qiblaBearingDeg: number;
}>;

const SIZE = 200;
const CENTER = SIZE / 2;
const RING_RADIUS = 94;
const CARDINAL_RADIUS = 72;
const TICKS = Array.from({ length: 60 }, (_, index) => index * 6);
const CARDINALS = [
  { deg: 0, label: "N", isNorth: true },
  { deg: 90, label: "E", isNorth: false },
  { deg: 180, label: "S", isNorth: false },
  { deg: 270, label: "W", isNorth: false },
];

const polar = (radius: number, deg: number) => {
  const radians = (deg * Math.PI) / 180;
  return {
    x: CENTER + radius * Math.sin(radians),
    y: CENTER - radius * Math.cos(radians),
  };
};

const gold = BRAND_COLORS.gold.DEFAULT;
const muted = BRAND_COLORS.onboarding.muted;

/** Static dial: 60 ticks, cardinals, Kaaba marker. Never re-renders. */
const QiblaCompassDialBase = ({ qiblaBearingDeg }: Props) => (
  <Svg width="100%" height="100%" viewBox={`0 0 ${SIZE} ${SIZE}`}>
    <Circle
      cx={CENTER}
      cy={CENTER}
      r={RING_RADIUS}
      stroke={gold}
      strokeOpacity={0.6}
      strokeWidth={1.5}
      fill="none"
    />

    {TICKS.map((deg) => {
      const isMajor = deg % 30 === 0;
      const inner = polar(isMajor ? 82 : 86, deg);
      const outer = polar(92, deg);
      return (
        <Line
          key={deg}
          x1={inner.x}
          y1={inner.y}
          x2={outer.x}
          y2={outer.y}
          stroke={isMajor ? gold : muted}
          strokeOpacity={isMajor ? 1 : 0.6}
          strokeWidth={isMajor ? 2 : 1}
          strokeLinecap="round"
        />
      );
    })}

    {CARDINALS.map(({ deg, label, isNorth }) => {
      const point = polar(CARDINAL_RADIUS, deg);
      return (
        <SvgText
          key={label}
          x={point.x}
          y={point.y}
          fill={isNorth ? gold : muted}
          fontSize={12}
          fontWeight="700"
          textAnchor="middle"
          dy={4}
        >
          {label}
        </SvgText>
      );
    })}

    <G transform={`rotate(${qiblaBearingDeg} ${CENTER} ${CENTER})`}>
      <Rect
        x={CENTER - 3.5}
        y={RING_RADIUS - 12}
        width={7}
        height={7}
        rx={1.5}
        fill={gold}
      />
      <Line
        x1={CENTER}
        y1={RING_RADIUS - 18}
        x2={CENTER}
        y2={RING_RADIUS - 14}
        stroke={gold}
        strokeWidth={2}
        strokeLinecap="round"
      />
    </G>
  </Svg>
);

export const QiblaCompassDial = memo(QiblaCompassDialBase);
