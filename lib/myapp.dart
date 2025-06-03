import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inventory_app/components/theme_provider.dart';
import 'package:inventory_app/core/themes/dark_theme.dart';
import 'package:inventory_app/core/themes/light_theme.dart';
import 'package:inventory_app/localization/S.dart';
import 'package:inventory_app/main.dart';
import 'package:inventory_app/screens/auth_screen.dart';
import 'package:inventory_app/screens/home_screen.dart';
import 'package:inventory_app/services/session_manager.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<SessionManager, ThemeProvider, LocaleProvider>(
      builder: (context, session, themeProvider, localeProvider, _) {
        return MaterialApp(
          title: 'Inventory App',
          themeMode: themeProvider.themeMode,
          locale: localeProvider.locale,
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

          home: session.isLoggedIn ? const HomeScreen() : const AuthScreen(),
        );
      },
    );
  }
}
