class SaveAyatReadBatchParams {
  const SaveAyatReadBatchParams({
    required this.date,
    required this.ayatIds,
  });

  final String date;
  final Set<String> ayatIds;
}
