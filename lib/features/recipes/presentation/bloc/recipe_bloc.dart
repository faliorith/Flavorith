import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flavorith/features/recipes/data/repositories/recipe_repository.dart';

// Events
abstract class RecipeEvent {}

// States
abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository recipeRepository;

  RecipeBloc({
    required this.recipeRepository,
  }) : super(RecipeInitial());
} 