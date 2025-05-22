// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flavorith/domain/models/recipe.dart';
import 'package:flavorith/domain/services/recipe_service.dart';
import 'package:flavorith/logic/cubits/recipe_cubit.dart';
import 'package:flavorith/presentation/pages/recipe_details/recipe_details_page.dart';
import 'package:flavorith/presentation/widgets/recipe_card.dart';

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
                return _buildRecipeCard(context, recipe);
              },
            );
          }
          
          return const Center(child: Text('Нет рецептов'));
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