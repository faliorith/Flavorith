// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flavorith/data/models/recipe.dart';
import 'package:flavorith/logic/cubits/recipe_cubit.dart';
import 'package:flavorith/presentation/pages/recipe_details/recipe_details_page.dart';

class CategoryRecipesPage extends StatelessWidget {
  final String categoryName;

  const CategoryRecipesPage({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: BlocBuilder<RecipeCubit, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is RecipeError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is RecipeLoaded) {
            final categoryRecipes = state.recipes.where((recipe) {
              // TODO: Add category field to Recipe model
              return true;
            }).toList();

            if (categoryRecipes.isEmpty) {
              return Center(
                child: Text('Нет рецептов в категории "$categoryName"'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categoryRecipes.length,
              itemBuilder: (context, index) {
                final recipe = categoryRecipes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
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
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'recipe_image_${recipe.id}',
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              recipe.imageUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
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
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.person_outline,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        recipe.authorName,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      recipe.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: recipe.isFavorite
                                          ? Colors.red
                                          : null,
                                    ),
                                    onPressed: () {
                                      // TODO: Implement toggle favorite
                                    },
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
              },
            );
          }

          return const Center(
            child: Text('Нет рецептов'),
          );
        },
      ),
    );
  }
} 