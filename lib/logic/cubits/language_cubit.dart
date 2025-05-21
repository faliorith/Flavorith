import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flavorith/core/constants/app_constants.dart';

class LanguageCubit extends Cubit<String> {
  final SharedPreferences _prefs;
  
  LanguageCubit(super.initialLanguage) 
      : _prefs = SharedPreferences.getInstance() as SharedPreferences;
  
  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(AppConstants.languageKey, languageCode);
    emit(languageCode);
  }
  
  String get currentLanguage => state;
} 