import 'package:equran_app/app.dart';
import 'package:equran_app/core/notifications/notification_service.dart';
import 'package:equran_app/injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await configureDependencies();
  await getIt<NotificationService>().init();
  runApp(const App());
}
