// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flavorith/core/theme/app_theme.dart';
import 'package:flavorith/logic/cubits/language_cubit.dart';
import 'package:flavorith/logic/cubits/theme_cubit.dart';
import 'package:flavorith/presentation/pages/splash/splash_page.dart';

class FlavorithApp extends StatelessWidget {
  const FlavorithApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        return BlocBuilder<LanguageCubit, String>(
          builder: (context, languageCode) {
            return MaterialApp(
              title: 'Flavorith',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              locale: Locale(languageCode),
              supportedLocales: const [
                Locale('en'),
                Locale('ru'),
                Locale('kk'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: const SplashPage(),
            );
          },
        );
      },
    );
  }
} 