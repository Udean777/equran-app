part of 'quran_reminder_cubit.dart';

@freezed
sealed class QuranReminderState with _$QuranReminderState {
  const factory QuranReminderState.initial() = QuranReminderInitial;
  const factory QuranReminderState.loaded(QuranReminderPrefs prefs) =
      QuranReminderLoaded;
  const factory QuranReminderState.error(Failure failure) = QuranReminderError;
}
