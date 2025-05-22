// ignore_for_file: deprecated_member_use, unused_import, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flavorith/core/theme/theme_provider.dart';
import 'package:flavorith/core/localization/language_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavorith/presentation/pages/auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Theme(
      data: themeProvider.isDarkMode
          ? ThemeData.dark().copyWith(
              primaryColor: theme.colorScheme.primary,
              colorScheme: ColorScheme.dark(
                primary: theme.colorScheme.primary,
                secondary: theme.colorScheme.secondary,
              ),
            )
          : ThemeData.light().copyWith(
              primaryColor: theme.colorScheme.primary,
              scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
              colorScheme: ColorScheme.light(
                primary: theme.colorScheme.primary,
                secondary: theme.colorScheme.secondary,
              ),
            ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(appLocalizations?.profile ?? 'Профиль'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: theme.appBarTheme.backgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Аватар и основная информация
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/profile_avatar.png'),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      user?.displayName ?? 'User Name',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    Text(
                      user?.email ?? 'homecook@faliorith.com',
                      style: TextStyle(
                        color: theme.textTheme.titleMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Настройки
              Text(
                appLocalizations?.settings ?? 'Настройки',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),

              const SizedBox(height: 15),

              // Переключение темы
              Card(
                elevation: 2,
                color: theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            appLocalizations?.darkTheme ?? 'Тёмная тема',
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                        activeColor: theme.colorScheme.primary,
                        activeTrackColor: theme.colorScheme.primary.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Выбор языка
              Card(
                elevation: 2,
                color: theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.language,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            appLocalizations?.language ?? 'Язык',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: languageProvider.currentLanguage,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: theme.colorScheme.primary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: theme.colorScheme.primary),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                        ),
                        items: ['Русский', 'English', 'Казахский'].map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            languageProvider.setLanguage(newValue);
                          }
                        },
                        dropdownColor: theme.cardColor,
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Дополнительные опции
              Text(
                appLocalizations?.more ?? 'Дополнительно',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),

              const SizedBox(height: 15),

              _buildOptionCard(
                icon: Icons.favorite,
                title: appLocalizations?.favorites ?? 'Избранное',
                onTap: () {
                  // Логика перехода на страницу избранного
                },
                isLogout: false,
                isDarkMode: isDarkMode,
                primaryColor: theme.colorScheme.primary,
                textColor: theme.textTheme.bodyMedium?.color,
                cardColor: theme.cardColor,
              ),

              _buildOptionCard(
                icon: Icons.settings,
                title: appLocalizations?.appSettings ?? 'Настройки приложения',
                onTap: () {
                  // Логика перехода на страницу настроек приложения
                },
                isLogout: false,
                isDarkMode: isDarkMode,
                primaryColor: theme.colorScheme.primary,
                textColor: theme.textTheme.bodyMedium?.color,
                cardColor: theme.cardColor,
              ),

              _buildOptionCard(
                icon: Icons.help_outline,
                title: appLocalizations?.help ?? 'Помощь',
                onTap: () {
                  // Логика перехода на страницу помощи
                },
                isLogout: false,
                isDarkMode: isDarkMode,
                primaryColor: theme.colorScheme.primary,
                textColor: theme.textTheme.bodyMedium?.color,
                cardColor: theme.cardColor,
              ),

              _buildOptionCard(
                icon: Icons.logout,
                title: appLocalizations?.logout ?? 'Выйти',
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    if (mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ошибка выхода: $e'),
                        ),
                      );
                    }
                  }
                },
                isLogout: true,
                isDarkMode: isDarkMode,
                primaryColor: theme.colorScheme.primary,
                textColor: theme.textTheme.bodyMedium?.color,
                cardColor: theme.cardColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
    required bool isDarkMode,
    required Color primaryColor,
    required Color? textColor,
    required Color cardColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(
                icon,
                color: isLogout ? Colors.red : primaryColor,
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isLogout
                      ? Colors.red
                      : textColor,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }
}