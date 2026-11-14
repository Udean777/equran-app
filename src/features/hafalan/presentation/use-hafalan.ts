import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import {
  addHafalanTarget,
  deleteHafalanTarget,
  listHafalan,
  listSetoranHistory,
} from "@/features/hafalan/data/hafalan-repository";
import { cancelMurajaahReminder } from "@/features/hafalan/data/murajaah-reminder-service";
import { computeHafalanStats } from "@/features/hafalan/domain/murajaah";
import { hafalanKeys } from "./hafalan-keys";

export const useHafalan = () => {
  const queryClient = useQueryClient();

  const listQuery = useQuery({
    queryKey: hafalanKeys.list(),
    queryFn: () => {
      const res = listHafalan();
      if (!res.ok) throw res.error;
      return res.value;
    },
  });

  const historyQuery = useQuery({
    queryKey: hafalanKeys.history(),
    queryFn: () => {
      const res = listSetoranHistory();
      if (!res.ok) throw res.error;
      return res.value;
    },
  });

  const addMutation = useMutation({
    mutationFn: async (surahNumber: number) => {
      const res = addHafalanTarget(surahNumber);
      if (!res.ok) throw res.error;
      return res.value;
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: hafalanKeys.all });
    },
  });

  const deleteMutation = useMutation({
    mutationFn: async (hafalanId: string) => {
      await cancelMurajaahReminder(hafalanId);
      const res = deleteHafalanTarget(hafalanId);
      if (!res.ok) throw res.error;
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: hafalanKeys.all });
    },
  });

  const items = listQuery.data ?? [];
  const history = historyQuery.data ?? [];
  const stats = computeHafalanStats(items, history);

  return {
    items,
    history,
    stats,
    isLoading: listQuery.isLoading || historyQuery.isLoading,
    addTarget: addMutation.mutateAsync,
    deleteTarget: deleteMutation.mutateAsync,
  };
};
