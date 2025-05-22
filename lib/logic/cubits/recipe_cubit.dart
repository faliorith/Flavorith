// ignore_for_file: unnecessary_null_comparison, unused_import

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flavorith/domain/models/recipe.dart';
import 'package:flavorith/data/repositories/recipe_repository.dart';

// Events
abstract class RecipeEvent {}

class LoadRecipes extends RecipeEvent {}

class SearchRecipes extends RecipeEvent {
  final String query;
  SearchRecipes(this.query);
}

class AddRecipe extends RecipeEvent {
  final Recipe recipe;
  AddRecipe(this.recipe);
}

class UpdateRecipe extends RecipeEvent {
  final String id;
  final Recipe recipe;
  UpdateRecipe(this.id, this.recipe);
}

class DeleteRecipe extends RecipeEvent {
  final String id;
  DeleteRecipe(this.id);
}

class ToggleFavorite extends RecipeEvent {
  final String id;
  final bool isFavorite;
  ToggleFavorite(this.id, this.isFavorite);
}

// State
abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;
  RecipeLoaded(this.recipes);
}

class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);
}

// Cubit
class RecipeCubit extends Cubit<RecipeState> {
  final RecipeRepository _repository;
  List<Recipe> _allRecipes = [];
  
  RecipeCubit({required RecipeRepository repository})
      : _repository = repository,
        super(RecipeInitial());
  
  Future<void> loadRecipes() async {
    emit(RecipeLoading());
    try {
      _allRecipes = await _repository.getRecipes();
      emit(RecipeLoaded(_allRecipes));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
  
  void searchRecipes(String query) {
    if (query.isEmpty) {
      emit(RecipeLoaded(_allRecipes));
      return;
    }

    final searchQuery = query.toLowerCase();
    final filteredRecipes = _allRecipes.where((recipe) {
      return recipe.title.toLowerCase().contains(searchQuery) ||
          recipe.description.toLowerCase().contains(searchQuery) ||
          recipe.ingredients.any((ingredient) =>
              ingredient.toLowerCase().contains(searchQuery));
    }).toList();

    emit(RecipeLoaded(filteredRecipes));
  }
  
  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _repository.addRecipe(recipe);
      loadRecipes();
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
  
  Future<void> updateRecipe(String id, Recipe recipe) async {
    try {
      await _repository.updateRecipe(id, recipe);
      loadRecipes();
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
  
  Future<void> deleteRecipe(String id) async {
    try {
      await _repository.deleteRecipe(id);
      loadRecipes();
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
  
  Future<void> toggleFavorite(String id, bool isFavorite) async {
    try {
      await _repository.toggleFavorite(id, isFavorite);
      loadRecipes();
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
} 