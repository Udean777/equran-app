import { useQuery } from "@tanstack/react-query";
import { useState } from "react";

import { getSurahDetail } from "../data/repository";
import { filterAyat } from "../domain/entities";
import { quranKeys } from "./quran-keys";

export const useSurahDetail = (surahNumber: number) => {
  const [searchQuery, setSearchQuery] = useState("");
  const query = useQuery({
    queryKey: quranKeys.surahDetail(surahNumber),
    queryFn: ({ signal }) => getSurahDetail(surahNumber, signal),
    staleTime: Infinity,
  });

  const result = query.data;
  const detail = result && result.ok ? result.value : null;
  const filteredAyat = detail ? filterAyat(detail.ayat, searchQuery) : [];
  const error = result && !result.ok ? result.error : null;

  return {
    detail,
    filteredAyat,
    searchQuery,
    setSearchQuery,
    isLoading: query.isPending,
    error,
    refetch: query.refetch,
  };
};
