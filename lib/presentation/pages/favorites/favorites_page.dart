// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flavorith/features/recipes/data/repositories/recipe_repository.dart';
import 'package:flavorith/domain/models/recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavorith/presentation/pages/recipe_details/recipe_details_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeRepository = Provider.of<RecipeRepository>(context);
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final theme = Theme.of(context);

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Избранное'),
          backgroundColor: theme.appBarTheme.backgroundColor,
        ),
        body: Center(
          child: Text(
            'Войдите, чтобы просмотреть избранные рецепты',
            style: TextStyle(color: theme.textTheme.bodyMedium?.color),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: StreamBuilder<List<Recipe>>(
        stream: recipeRepository.getFavoriteRecipes(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Ошибка загрузки избранных рецептов: ${snapshot.error}', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('У вас пока нет избранных рецептов', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
            );
          }

          final favoriteRecipes = snapshot.data!;

          return ListView.builder(
            itemCount: favoriteRecipes.length,
            itemBuilder: (context, index) {
              final recipe = favoriteRecipes[index];
              return _buildRecipeCard(context, recipe);
            },
          );
        },
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Recipe recipe) {
    return Card(
      child: ListTile(
        leading: recipe.imageUrl.isNotEmpty
            ? Image.network(
                recipe.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              )
            : const Icon(Icons.restaurant),
        title: Text(recipe.title),
        subtitle: Text(
          'Автор: ${recipe.authorName}\nЛайки: ${recipe.likesCount}',
          maxLines: 2,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailsPage(recipe: recipe),
            ),
          );
        },
      ),
    );
  }
} 