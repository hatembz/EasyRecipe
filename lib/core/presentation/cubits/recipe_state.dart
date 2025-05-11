import 'package:easy_recipe/core/domain/entities/recipe.dart';

abstract class RecipeState {}

class RecipeInitial extends RecipeState {
  final List<Recipe> recipes;

  RecipeInitial([this.recipes = const []]);
}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;

  RecipeLoaded(this.recipes);
}

class RecipeError extends RecipeState {
  final String message;

  RecipeError(this.message);
}

class RecipeOperationSuccess extends RecipeState {
  final String message;

  RecipeOperationSuccess(this.message);
}

class StepTrackingSuccess extends RecipeState {
  final String recipeId;
  final int currentStep;
  final int totalSteps;

  StepTrackingSuccess({
    required this.recipeId,
    required this.currentStep,
    required this.totalSteps,
  });
}
