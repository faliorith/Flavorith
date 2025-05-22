// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flavorith/features/recipes/data/repositories/recipe_repository.dart';
import 'package:flavorith/domain/models/recipe.dart';
import 'package:flavorith/logic/cubits/recipe_cubit.dart';
import 'package:flavorith/presentation/widgets/recipe_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchQueryChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipeRepository = Provider.of<RecipeRepository>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск рецептов'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Введите название рецепта',
                labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.secondary),
                ),
              ),
              style: TextStyle(color: theme.textTheme.bodyMedium?.color),
              onChanged: _onSearchQueryChanged,
            ),
          ),
          Expanded(
            child: _searchQuery.isEmpty
                ? Center(
                    child: Text(
                      'Введите запрос для поиска',
                      style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                    ),
                  )
                : StreamBuilder<List<Recipe>>(
                    stream: recipeRepository.searchRecipes(_searchQuery),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Ошибка поиска: ${snapshot.error}', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('Рецепты не найдены', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                        );
                      }

                      final searchResults = snapshot.data!;

                      return ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final recipe = searchResults[index];
                          return Card(
                            color: theme.cardColor,
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            elevation: 1,
                            child: ListTile(
                              title: Text(
                                recipe.title,
                                style: TextStyle(color: theme.textTheme.titleMedium?.color),
                              ),
                              subtitle: Text(
                                recipe.description,
                                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                              ),
                              // Добавить изображение, onTap и т.д.
                            ),
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