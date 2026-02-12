import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'app_router.dart'; // [Restore]
import 'viewmodels/theme_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
  }

  // [Fix] 한국어 날짜 포맷 초기화
  await initializeDateFormatting('ko_KR', null);

  Intl.defaultLocale = 'ko_KR';

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const BukkuApp(),
    ),
  );
}

class BukkuApp extends StatelessWidget {
  const BukkuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '북끄',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: const Color(0xFFFDFBF7), // 크림 화이트
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFDFBF7),
          foregroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
          secondary: Colors.grey,
          surface: Colors.white,
        ),
      ),
      // [GoRouter 연결]
      routerConfig: routerConfig,
    );
  }
}
