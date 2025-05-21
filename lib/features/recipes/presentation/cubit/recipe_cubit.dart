import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flavorith/features/recipes/domain/models/recipe.dart';
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
  final String userId;

  const ToggleFavorite(this.recipeId, this.userId);

  @override
  List<Object> get props => [recipeId, userId];
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
  final RecipeRepository recipeRepository;

  RecipeCubit({required this.recipeRepository}) : super(RecipeInitial());

  void loadRecipes() {
    emit(RecipeLoading());
    recipeRepository.getRecipes().listen(
      (recipes) => emit(RecipeLoaded(recipes)),
      onError: (error) => emit(RecipeError(error.toString())),
    );
  }

  void searchRecipes(String query) {
    emit(RecipeLoading());
    recipeRepository.searchRecipes(query).listen(
      (recipes) => emit(RecipeLoaded(recipes)),
      onError: (error) => emit(RecipeError(error.toString())),
    );
  }

  void loadRecipesByCategory(String category) {
    emit(RecipeLoading());
    recipeRepository.getRecipesByCategory(category).listen(
      (recipes) => emit(RecipeLoaded(recipes)),
      onError: (error) => emit(RecipeError(error.toString())),
    );
  }

  void loadFavoriteRecipes(String userId) {
    emit(RecipeLoading());
    recipeRepository.getFavoriteRecipes(userId).listen(
      (recipes) => emit(RecipeLoaded(recipes)),
      onError: (error) => emit(RecipeError(error.toString())),
    );
  }

  Future<void> toggleFavorite(String recipeId, String userId) async {
    try {
      await recipeRepository.toggleFavorite(recipeId, userId);
    } catch (error) {
      emit(RecipeError(error.toString()));
    }
  }
} 