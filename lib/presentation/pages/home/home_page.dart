// ignore_for_file: unused_import, unnecessary_null_comparison, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flavorith/core/constants/app_constants.dart';
import 'package:flavorith/features/recipes/presentation/cubit/recipe_cubit.dart';
import 'package:flavorith/domain/models/recipe.dart';
import 'package:flavorith/presentation/pages/add_recipe/add_recipe_page.dart';
import 'package:flavorith/presentation/pages/recipe_details/recipe_details_page.dart';

// Remove the temporary placeholder AddRecipePage
// class AddRecipePage extends StatelessWidget {
//   const AddRecipePage({super.key});
//   @override
//   Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Добавить рецепт')));
// }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flavorith'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: RecipeSearchDelegate(
                  context.read<RecipeCubit>(),
                ),
              );
            },
          ),
        ],
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
            if (state.recipes.isEmpty) {
              return const Center(child: Text('Нет рецептов'));
            }
            return ListView.builder(
              itemCount: state.recipes.length,
              itemBuilder: (context, index) {
                final recipe = state.recipes[index];
                return _buildRecipeCard(context, recipe);
              },
            );
          }
          
          return const Center(child: Text('Нет рецептов'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRecipePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
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

class RecipeSearchDelegate extends SearchDelegate<Recipe?> {
  final RecipeCubit _cubit;

  RecipeSearchDelegate(this._cubit);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _cubit.searchRecipes(query);
    return BlocBuilder<RecipeCubit, RecipeState>(
      builder: (context, state) {
        if (state is RecipeLoaded) {
          if (state.recipes.isEmpty) {
            return const Center(child: Text('Рецепты не найдены'));
          }
          return ListView.builder(
            itemCount: state.recipes.length,
            itemBuilder: (context, index) {
              final recipe = state.recipes[index];
              return ListTile(
                title: Text(recipe.title),
                subtitle: Text(recipe.description),
                onTap: () {
                  close(context, recipe);
                },
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
} 