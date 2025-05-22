// ignore_for_file: deprecated_member_use, unused_import, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flavorith/domain/models/recipe.dart';
import 'package:flavorith/presentation/pages/recipe_details/recipe_details_page.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение рецепта
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: recipe.imageUrl != null
                  ? Image.network(
                      recipe.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: theme.colorScheme.surfaceVariant,
                          child: Icon(
                            Icons.restaurant,
                            size: 64,
                            color: theme.colorScheme.primary,
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 200,
                      color: theme.colorScheme.surfaceVariant,
                      child: Icon(
                        Icons.restaurant,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название рецепта
                  Text(
                    recipe.title,
                    style: theme.textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Описание рецепта
                  Text(
                    recipe.description,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  // Информация о рецепте
                  Row(
                    children: [
                      // Время приготовления
                      Icon(
                        Icons.timer_outlined,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.cookingTime} мин',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 16),
                      // Сложность
                      Icon(
                        Icons.fitness_center_outlined,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getDifficultyText(recipe.difficulty),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDifficultyText(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return 'Легко';
      case 'medium':
        return 'Средне';
      case 'hard':
        return 'Сложно';
      default:
        return 'Средне';
    }
  }
} 