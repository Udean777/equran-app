import { useQuery } from "@tanstack/react-query";
import { useState } from "react";
import { useTranslation } from "react-i18next";

import { getSurahDetail } from "../data/repository";
import { filterAyat, resolveQuranLanguage } from "../domain/entities";
import { quranKeys } from "./quran-keys";

export const useSurahDetail = (surahNumber: number) => {
  const { i18n } = useTranslation();
  const language = resolveQuranLanguage(i18n.language);
  const [searchQuery, setSearchQuery] = useState("");

  const query = useQuery({
    queryKey: quranKeys.surahDetail(surahNumber, language),
    queryFn: ({ signal }) => getSurahDetail(surahNumber, language, signal),
    staleTime: Infinity,
  });

  const result = query.data;
  const detail = result && result.ok ? result.value : null;
  const filteredAyat = detail ? filterAyat(detail.ayat, searchQuery) : [];
  const error = result && !result.ok ? result.error : null;

  return {
    detail,
    filteredAyat,
    language,
    searchQuery,
    setSearchQuery,
    isLoading: query.isPending,
    error,
    refetch: query.refetch,
  };
};
