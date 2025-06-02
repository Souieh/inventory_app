import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inventory_app/components/theme_provider.dart';
import 'package:inventory_app/core/themes/dark_theme.dart';
import 'package:inventory_app/core/themes/light_theme.dart';
import 'package:inventory_app/localization/S.dart';
import 'package:inventory_app/providers/dev_mode_provider.dart';
import 'package:inventory_app/screens/auth_screen.dart';
import 'package:inventory_app/screens/home_screen.dart';
import 'package:inventory_app/services/session_manager.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

bool isIOS = Platform.isIOS;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionManager()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => DevModeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, _) {
        if (isIOS) {
          return CupertinoApp(
            locale: localeProvider.locale, // ✅ هنا
            home: Consumer<SessionManager>(
              builder: (context, session, _) {
                return session.isLoggedIn
                    ? const HomeScreen()
                    : const AuthScreen();
              },
            ),
            // تعيين الثيم المناسب
          );
        } else {
          return MaterialApp(
            title: 'Inventory App',
            themeMode: themeProvider.themeMode,
            locale: localeProvider.locale, // ✅ هنا
            theme: lightTheme,
            darkTheme: darkTheme,

            // Localization setup for intl
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.supportedLocales,

            // Automatically detect system locale
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },

            home: Consumer<SessionManager>(
              builder: (context, session, _) {
                return session.isLoggedIn
                    ? const HomeScreen()
                    : const AuthScreen();
              },
            ),
          );
        }
      },
    );
  }
}

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
