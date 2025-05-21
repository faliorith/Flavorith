import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flavorith/logic/cubits/language_cubit.dart';
import 'package:flavorith/logic/cubits/theme_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavorith/presentation/pages/auth/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              user?.email?.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.email ?? 'Пользователь',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Язык'),
            trailing: DropdownButton<String>(
              value: context.watch<LanguageCubit>().currentLanguage,
              items: const [
                DropdownMenuItem(
                  value: 'ru',
                  child: Text('Русский'),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: 'kk',
                  child: Text('Қазақша'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  context.read<LanguageCubit>().setLanguage(value);
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Темная тема'),
            trailing: Switch(
              value: context.watch<ThemeCubit>().isDarkMode,
              onChanged: (value) {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('О приложении'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Flavorith',
                applicationVersion: '1.0.0',
                applicationIcon: const FlutterLogo(size: 50),
                children: const [
                  Text('Приложение для хранения и обмена рецептами.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
} 