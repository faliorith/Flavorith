// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flavorith/features/recipes/domain/models/recipe.dart';
import 'package:flavorith/logic/cubits/recipe_cubit.dart';
import 'package:flavorith/presentation/pages/recipe_details/recipe_details_page.dart';

class CategoryRecipesPage extends StatelessWidget {
  final String category;

  const CategoryRecipesPage({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: BlocBuilder<RecipeCubit, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is RecipeError) {
            return Center(child: Text(state.message));
          }
          
          if (state is RecipeLoaded) {
            final categoryRecipes = state.recipes.where(
              (recipe) => recipe.category == category,
            ).toList();

            if (categoryRecipes.isEmpty) {
              return Center(
                child: Text('Нет рецептов в категории $category'),
              );
            }

            return ListView.builder(
              itemCount: categoryRecipes.length,
              itemBuilder: (context, index) {
                final recipe = categoryRecipes[index];
                return RecipeCard(recipe: recipe);
              },
            );
          }
          
          return const Center(child: Text('Нет рецептов'));
        },
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailsPage(recipe: recipe),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'recipe_image_${recipe.id}',
              child: Image.network(
                recipe.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          recipe.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: recipe.isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          context.read<RecipeCubit>().toggleFavorite(
                            recipe.id,
                            !recipe.isFavorite,
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        recipe.authorName,
                        style: Theme.of(context).textTheme.bodySmall,
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
} 