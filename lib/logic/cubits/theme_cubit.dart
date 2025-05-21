import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flavorith/core/constants/app_constants.dart';

class ThemeCubit extends Cubit<bool> {
  final SharedPreferences _prefs;
  
  ThemeCubit(super.isDarkMode) 
      : _prefs = SharedPreferences.getInstance() as SharedPreferences;
  
  Future<void> toggleTheme() async {
    final newValue = !state;
    await _prefs.setBool(AppConstants.darkModeKey, newValue);
    emit(newValue);
  }
  
  bool get isDarkMode => state;
} 