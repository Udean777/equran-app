import 'package:equran_app/features/tasbih/domain/entities/tasbih_preset.dart';
import 'package:equran_app/features/tasbih/domain/entities/tasbih_session.dart';

final TasbihPreset tPreset =
    TasbihPreset.defaults.first; // Subhanallah, target 33

final tSession = TasbihSession(
  id: '1748166000000',
  presetId: 'subhanallah',
  presetName: 'Subhanallah',
  count: 33,
  target: 33,
  createdAt: DateTime(2026, 5, 25, 12),
);

final tSession2 = TasbihSession(
  id: '1748166060000',
  presetId: 'alhamdulillah',
  presetName: 'Alhamdulillah',
  count: 33,
  target: 33,
  createdAt: DateTime(2026, 5, 25, 13),
);
