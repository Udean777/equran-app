part of 'notification_test_viewmodel.dart';

@freezed
sealed class NotificationTestState with _$NotificationTestState {
  const factory NotificationTestState.initial({
    @Default({}) Map<String, bool> statuses,
  }) = NotificationTestInitial;

  const factory NotificationTestState.running({
    required Map<String, bool> statuses,
  }) = NotificationTestRunning;

  const factory NotificationTestState.error({
    required Map<String, bool> statuses,
    required Failure failure,
  }) = NotificationTestError;
}
