import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flavorith/features/recipes/domain/models/recipe.dart';
import 'package:flavorith/logic/cubits/recipe_cubit.dart';
import 'package:flavorith/presentation/pages/recipe_details/recipe_details_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
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
            final favoriteRecipes = state.recipes.where(
              (recipe) => recipe.isFavorite,
            ).toList();

            if (favoriteRecipes.isEmpty) {
              return const Center(
                child: Text('Нет избранных рецептов'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        recipe.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(recipe.title),
                    subtitle: Text(recipe.authorName),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        context.read<RecipeCubit>().toggleFavorite(
                          recipe.id,
                          false,
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailsPage(
                            recipe: recipe,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          
          return const Center(child: Text('Нет избранных рецептов'));
        },
      ),
    );
  }
} 