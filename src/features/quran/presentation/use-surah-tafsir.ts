import { useQuery } from "@tanstack/react-query";
import { useState } from "react";

import { getSurahTafsir } from "../data/repository";
import { filterTafsirEntries } from "../domain/entities";
import { quranKeys } from "./quran-keys";

export const useSurahTafsir = (surahNumber: number) => {
  const [searchQuery, setSearchQuery] = useState("");
  const query = useQuery({
    queryKey: quranKeys.tafsir(surahNumber),
    queryFn: ({ signal }) => getSurahTafsir(surahNumber, signal),
    staleTime: Infinity,
  });

  const result = query.data;
  const tafsir = result && result.ok ? result.value : null;
  const filteredEntries = tafsir
    ? filterTafsirEntries(tafsir.entries, searchQuery)
    : [];
  const error = result && !result.ok ? result.error : null;

  return {
    tafsir,
    filteredEntries,
    searchQuery,
    setSearchQuery,
    isLoading: query.isPending,
    error,
    refetch: query.refetch,
  };
};
