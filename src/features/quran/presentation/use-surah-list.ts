import { useQuery } from "@tanstack/react-query";
import { useState } from "react";

import { getSurahList } from "../data/repository";
import { filterSurahs, type RevelationFilter } from "../domain/entities";
import { quranKeys } from "./quran-keys";

export const useSurahList = () => {
  const [searchQuery, setSearchQuery] = useState("");
  const [revelationFilter, setRevelationFilter] =
    useState<RevelationFilter>("all");
  const query = useQuery({
    queryKey: quranKeys.surahList(),
    queryFn: ({ signal }) => getSurahList(signal),
    staleTime: Infinity,
  });

  const result = query.data;
  const allSurahs = result && result.ok ? result.value : [];
  const surahs = filterSurahs(allSurahs, searchQuery, revelationFilter);
  const error = result && !result.ok ? result.error : null;

  return {
    surahs,
    totalCount: allSurahs.length,
    searchQuery,
    setSearchQuery,
    revelationFilter,
    setRevelationFilter,
    isLoading: query.isPending,
    error,
    refetch: query.refetch,
  };
};
