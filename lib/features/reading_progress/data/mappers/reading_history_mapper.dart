import 'package:equran_app/features/reading_progress/data/models/reading_history_dto.dart';
import 'package:equran_app/features/reading_progress/domain/entities/reading_history.dart';

extension ReadingHistoryDtoMapper on ReadingHistoryDto {
  ReadingHistory toEntity() => ReadingHistory(
    date: date,
    ayatRead: ayatRead.toSet(),
  );
}

extension ReadingHistoryMapper on ReadingHistory {
  ReadingHistoryDto toDto() => ReadingHistoryDto(
    date: date,
    ayatRead: ayatRead.toList(),
  );
}
