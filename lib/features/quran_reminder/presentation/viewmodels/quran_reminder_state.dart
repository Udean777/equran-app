import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/quran_reminder/domain/entities/quran_reminder_prefs.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quran_reminder_state.freezed.dart';

@freezed
sealed class QuranReminderState with _$QuranReminderState {
  const factory QuranReminderState.initial() = QuranReminderInitial;
  const factory QuranReminderState.loaded(QuranReminderPrefs prefs) =
      QuranReminderLoaded;
  const factory QuranReminderState.error(Failure failure) = QuranReminderError;
}
