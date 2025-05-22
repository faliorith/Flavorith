// ignore_for_file: prefer_const_constructors, no_logic_in_create_state, no_leading_underscores_for_local_identifiers, unused_element, non_constant_identifier_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flavorith/domain/models/recipe.dart';
import 'package:flavorith/domain/services/recipe_service.dart';
import 'package:flavorith/presentation/widgets/recipe_card.dart';
import 'package:flavorith/presentation/pages/recipes/recipe_details_page.dart';
import 'package:flavorith/presentation/pages/recipes/recipe_edit_page.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({Key? key}) : super(key: key);

  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final RecipeService _recipeService = RecipeService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedDifficulty = 'all';
  int? _maxCookingTime;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<List<Recipe>> _getFilteredRecipes() {
    if (_searchQuery.isNotEmpty) {
      return _recipeService.searchRecipes(_searchQuery);
    }

    if (_selectedDifficulty != 'all') {
      return _recipeService.getRecipesByDifficulty(_selectedDifficulty);
    }

    if (_maxCookingTime != null) {
      return _recipeService.getRecipesByCookingTime(_maxCookingTime!);
    }

    return _recipeService.getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Рецепты'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeEditPage(recipe: null,),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Поиск и фильтры
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Поле поиска
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Поиск рецептов...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                const SizedBox(height: 16),
                // Фильтры
                Row(
                  children: [
                    // Фильтр по сложности
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedDifficulty,
                        decoration: InputDecoration(
                          labelText: 'Сложность',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text('Все'),
                          ),
                          DropdownMenuItem(
                            value: 'easy',
                            child: Text('Легко'),
                          ),
                          DropdownMenuItem(
                            value: 'medium',
                            child: Text('Средне'),
                          ),
                          DropdownMenuItem(
                            value: 'hard',
                            child: Text('Сложно'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedDifficulty = value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Фильтр по времени
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        value: _maxCookingTime,
                        decoration: InputDecoration(
                          labelText: 'Время',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: null,
                            child: Text('Любое'),
                          ),
                          DropdownMenuItem(
                            value: 30,
                            child: Text('До 30 мин'),
                          ),
                          DropdownMenuItem(
                            value: 60,
                            child: Text('До 1 часа'),
                          ),
                          DropdownMenuItem(
                            value: 120,
                            child: Text('До 2 часов'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => _maxCookingTime = value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Список рецептов
          Expanded(
            child: StreamBuilder<List<Recipe>>(
              stream: _getFilteredRecipes(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Ошибка: ${snapshot.error}',
                      style: theme.textTheme.bodyLarge,
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final recipes = snapshot.data!;

                if (recipes.isEmpty) {
                  return Center(
                    child: Text(
                      'Рецепты не найдены',
                      style: theme.textTheme.bodyLarge,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailsPage(
                              recipeId: recipe.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}