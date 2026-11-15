import { useLocalSearchParams } from "expo-router";

import { Screen } from "@/components/screen";
import { StateView } from "@/components/state-view";
import { SurahNumberSchema } from "@/features/quran/data/schema";
import { SurahDetailScreen } from "@/features/quran/presentation/surah-detail-screen";

export default function SurahDetailRoute() {
  const { number } = useLocalSearchParams<{ number?: string }>();
  const parsed = SurahNumberSchema.safeParse(number);

  if (!parsed.success) {
    return (
      <Screen>
        <StateView kind="error" errorCode="notFound" />
      </Screen>
    );
  }

  return <SurahDetailScreen surahNumber={parsed.data} />;
}
