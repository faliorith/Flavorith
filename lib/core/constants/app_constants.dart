class AppConstants {
  // SharedPreferences keys
  static const String languageKey = 'language';
  static const String darkModeKey = 'darkMode';
  static const String userKey = 'user';
  
  // Firebase collections
  static const String recipesCollection = 'recipes';
  static const String usersCollection = 'users';
  
  // API endpoints
  static const String baseUrl = 'https://api.flavorith.com';
  
  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  // Routes
  static const String splashRoute = '/';
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String profileRoute = '/profile';
  static const String addRecipeRoute = '/add-recipe';
  static const String recipeDetailsRoute = '/recipe-details';
  
  // Asset paths
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderImagePath = 'assets/images/placeholder.png';
} 