import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flavorith/core/services/firebase_service.dart';
import 'package:flavorith/features/recipes/presentation/cubit/recipe_cubit.dart';
import 'package:flavorith/features/recipes/data/repositories/recipe_repository.dart';
import 'package:flavorith/presentation/pages/home/home_page.dart';
import 'package:flavorith/core/theme/app_theme.dart';
import 'package:flavorith/generated/l10n.dart' as l10n;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Firebase
  final firebaseService = FirebaseService();
  await firebaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => RecipeRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => RecipeCubit(
              recipeRepository: context.read<RecipeRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flavorith',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          localizationsDelegates: const [
            l10n.AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: l10n.AppLocalizations.delegate.supportedLocales,
          home: const HomePage(),
        ),
      ),
    );
  }
}