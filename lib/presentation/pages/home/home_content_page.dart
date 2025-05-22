import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flavorith/features/recipes/data/repositories/recipe_repository.dart';
import 'package:flavorith/domain/models/recipe.dart';
import 'package:flavorith/presentation/pages/recipe_details/recipe_details_page.dart';

class HomeContentPage extends StatelessWidget {
  const HomeContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeRepository = Provider.of<RecipeRepository>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Рецепты'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: FutureBuilder<List<Recipe>>(
        future: recipeRepository.getRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Ошибка загрузки рецептов: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Рецепты пока не добавлены'),
            );
          }

          final recipes = snapshot.data!;

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
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