import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

const _streakLastDateKey = 'quran_streak_last_date';
const _streakCountKey = 'quran_streak_count';

@singleton
class QuranStreakCubit extends Cubit<int> {
  QuranStreakCubit(@Named('settingsBox') this._box) : super(0);

  final Box<String> _box;

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  /// Load streak count dari Hive.
  void load() {
    final count = int.tryParse(_box.get(_streakCountKey) ?? '') ?? 0;
    emit(count);
  }

  /// Dipanggil saat user membuka SuratDetailPage.
  ///
  /// Logic:
  /// - Hari ini → tidak ada perubahan
  /// - Kemarin → streak++
  /// - Lebih dari kemarin / null → reset ke 1
  Future<void> recordRead() async {
    final today = _dateFormat.format(DateTime.now());
    final lastDate = _box.get(_streakLastDateKey);

    if (lastDate == today) return; // sudah baca hari ini

    final yesterday = _dateFormat.format(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    final newCount = lastDate == yesterday ? state + 1 : 1;

    await _box.put(_streakLastDateKey, today);
    await _box.put(_streakCountKey, newCount.toString());
    emit(newCount);
  }
}
