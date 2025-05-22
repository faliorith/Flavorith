// ignore_for_file: avoid_print, unnecessary_import, unused_import

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Для отладки
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flavorith/features/recipes/data/repositories/recipe_repository.dart';
import 'package:flavorith/presentation/pages/main/main_navigation.dart';
import 'package:flavorith/presentation/pages/auth/login_page.dart';
import 'package:flavorith/core/theme/app_theme.dart';
import 'package:flavorith/core/theme/theme_provider.dart';
import 'package:flavorith/core/localization/language_provider.dart';
import 'package:flavorith/generated/l10n.dart' as l10n;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flavorith/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:flavorith/presentation/pages/splash_screen.dart';
import 'package:flavorith/presentation/pages/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flavorith/core/services/auth_service.dart';

void main() async {
  try {
    // Инициализация Flutter
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('Flutter initialized');
    
    // Инициализация Firebase Core, только если он еще не инициализирован
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCrTAea9QcUyffDzkoQEUCMmSM8tlahX5U",
          appId: "1:1051674072588:android:5694c3acaee6f8bfe3c029",
          messagingSenderId: "1051674072588",
          projectId: "flavorith",
          databaseURL: "https://flavorith-default-rtdb.firebaseio.com",
          storageBucket: "flavorith.appspot.com",
        ),
      );
       debugPrint('Firebase Core initialized');
    } else {
       debugPrint('Firebase Core already initialized');
    }
   
    
    // Проверка подключения к Realtime Database
    final database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    debugPrint('Realtime Database persistence enabled');
    
    // Проверка подключения к базе данных
    try {
      final testRef = database.ref().child('test');
      await testRef.set({'test': 'test'});
      await testRef.remove();
      debugPrint('Database connection test successful');
    } catch (e) {
      debugPrint('Database connection test failed: $e');
      rethrow;
    }
    
    // Инициализация сервисов FirebaseService - теперь после инициализации Core
    // final firebaseService = FirebaseService(); // Закомментировано, если FirebaseService не используется напрямую для инициализации
    // await firebaseService.initialize(); // Закомментировано
    debugPrint('Firebase services initialized');
    
    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint('Error initializing app: $e');
    debugPrint('Stack trace: $stackTrace');
    // Показываем ошибку пользователю
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ошибка инициализации приложения',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                e.toString(),
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RecipeRepository>(
          create: (_) => RecipeRepository(FirebaseFirestore.instance),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (_) => LanguageProvider(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // BlocProvider( // Закомментировано
          //   create: (context) => AuthBloc( // Закомментировано
          //     authRepository: context.read<AuthRepository>(), // Закомментировано
          //   ), // Закомментировано
          // ), // Закомментировано
          // BlocProvider( // Закомментировано
          //   create: (context) => UserBloc( // Закомментировано
          //     userRepository: context.read<UserRepository>(), // Закомментировано
          //   ), // Закомментировано
          // ), // Закомментировано
          BlocProvider( // Если RecipeBloc существует
            create: (context) => RecipeBloc(
              recipeRepository: context.read<RecipeRepository>(),
            ),
          ),
        ],
        child: Builder(
          builder: (context) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            final languageProvider = Provider.of<LanguageProvider>(context);
            
            return MaterialApp(
              title: 'Flavorith',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              locale: languageProvider.currentLocale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SplashScreen();
                  }
                  if (snapshot.hasData) {
                    return const HomePage();
                  }
                  return const LoginPage();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}