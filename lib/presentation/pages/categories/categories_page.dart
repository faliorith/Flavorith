// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flavorith/presentation/pages/category_recipes/category_recipes_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Основные блюда',
        'icon': Icons.restaurant,
        'color': const Color(0xFF7D8F69),
      },
      {
        'name': 'Десерты',
        'icon': Icons.cake,
        'color': const Color(0xFFE6D5AC),
      },
      {
        'name': 'Напитки',
        'icon': Icons.local_drink,
        'color': const Color(0xFF9BAF88),
      },
      {
        'name': 'Закуски',
        'icon': Icons.tapas,
        'color': const Color(0xFF7D8F69),
      },
      {
        'name': 'Супы',
        'icon': Icons.soup_kitchen,
        'color': const Color(0xFFE6D5AC),
      },
      {
        'name': 'Салаты',
        'icon': Icons.eco,
        'color': const Color(0xFF9BAF88),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return TweenAnimationBuilder(
            duration: Duration(milliseconds: 300 + (index * 100)),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryRecipesPage(
                        category: category['name'] as String,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        category['color'] as Color,
                        (category['color'] as Color).withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category['icon'] as IconData,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        category['name'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 