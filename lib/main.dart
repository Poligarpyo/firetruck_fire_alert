import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'core/storage/auth_local_datasource.dart';
import 'firebase_options.dart';
import 'hive/hive.dart';
import 'my_app.dart';
import 'shared/constants/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initHive();
  await setPreferredOrientations();
  await Hive.initFlutter();
  await Hive.openBox<dynamic>(authBoxName);
  await dotenv.load(fileName: ".env");
  final container = ProviderContainer();
  // await container.read(appInitializerProvider.future);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('tr')],
        path: Strings.localizationsPath,
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    ),
  );
}
