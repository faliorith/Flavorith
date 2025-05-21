import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flavorith/core/constants/app_constants.dart';
import 'package:flavorith/logic/cubits/language_cubit.dart';
import 'package:flavorith/logic/cubits/theme_cubit.dart';
import 'package:flavorith/core/theme/app_theme.dart';
import 'package:flavorith/firebase_options.dart';
import 'package:flavorith/logic/cubits/recipe_cubit.dart';
import 'package:flavorith/data/repositories/recipe_repository.dart';
import 'package:flavorith/presentation/pages/welcome/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Инициализация SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final recipeRepository = RecipeRepository();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LanguageCubit(
            prefs.getString(AppConstants.languageKey) ?? 'ru',
          ),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(
            prefs.getBool(AppConstants.darkModeKey) ?? false,
          ),
        ),
        BlocProvider(
          create: (context) => RecipeCubit(repository: recipeRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        return MaterialApp(
          title: 'Flavorith',
          theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ru'),
          ],
          locale: Locale(context.read<LanguageCubit>().state),
          home: const WelcomePage(),
        );
      },
    );
  }
}