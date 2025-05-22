import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flavorith/domain/models/recipe.dart';
import 'package:flavorith/features/recipes/data/repositories/recipe_repository.dart';

// Events
abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class LoadRecipes extends RecipeEvent {}

class SearchRecipes extends RecipeEvent {
  final String query;

  const SearchRecipes(this.query);

  @override
  List<Object> get props => [query];
}

class LoadRecipesByCategory extends RecipeEvent {
  final String category;

  const LoadRecipesByCategory(this.category);

  @override
  List<Object> get props => [category];
}

class LoadFavoriteRecipes extends RecipeEvent {
  final String userId;

  const LoadFavoriteRecipes(this.userId);

  @override
  List<Object> get props => [userId];
}

class ToggleFavorite extends RecipeEvent {
  final String recipeId;
  final bool isFavorite;

  const ToggleFavorite(this.recipeId, this.isFavorite);

  @override
  List<Object> get props => [recipeId, isFavorite];
}

// States
abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;

  const RecipeLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class RecipeCubit extends Cubit<RecipeState> {
  final RecipeRepository _recipeRepository;

  RecipeCubit(this._recipeRepository) : super(RecipeInitial());

  Future<void> loadRecipes() async {
    emit(RecipeLoading());
    try {
      final recipes = await _recipeRepository.getRecipes();
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  void searchRecipes(String query) {
    emit(RecipeLoading());
    _recipeRepository.searchRecipes(query).listen(
      (recipes) => emit(RecipeLoaded(recipes)),
      onError: (error) => emit(RecipeError(error.toString())),
    );
  }

  void loadRecipesByCategory(String category) {
    emit(RecipeLoading());
    _recipeRepository.getRecipesByCategory(category).listen(
      (recipes) => emit(RecipeLoaded(recipes)),
      onError: (error) => emit(RecipeError(error.toString())),
    );
  }

  void loadFavoriteRecipes(String userId) {
    emit(RecipeLoading());
    _recipeRepository.getFavoriteRecipes(userId).listen(
      (recipes) => emit(RecipeLoaded(recipes)),
      onError: (error) => emit(RecipeError(error.toString())),
    );
  }

  Future<void> toggleFavorite(String recipeId, bool isFavorite) async {
    try {
      final currentState = state;
      if (currentState is RecipeLoaded) {
        final recipe = currentState.recipes.firstWhere((r) => r.id == recipeId);
        final updatedRecipe = recipe.copyWith(
          isFavorite: isFavorite,
          likesCount: isFavorite ? recipe.likesCount + 1 : recipe.likesCount - 1,
        );
        
        await _recipeRepository.updateRecipe(updatedRecipe);
        emit(RecipeLoaded(
          currentState.recipes.map((r) => r.id == recipeId ? updatedRecipe : r).toList(),
        ));
      }
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
} 