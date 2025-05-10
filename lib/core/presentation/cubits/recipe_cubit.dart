import 'package:easy_recipe/core/domain/entities/recipe.dart';
import 'package:easy_recipe/core/domain/repositories/recipe_repository.dart';
import 'package:easy_recipe/core/presentation/cubits/recipe_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final RecipeRepository _repository;

  RecipeCubit(this._repository) : super(RecipeInitial()) {
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    emit(RecipeLoading());
    try {
      await for (final recipes in _repository.getRecipes()) {
        emit(RecipeLoaded(recipes));
      }
    } catch (e) {
      emit(RecipeError('Failed to load recipes'));
    }
  }

  Future<void> addRecipe({
    required String name,
    required String imageUrl,
    required String description,
    required List<String> cookingSteps,
    required int cookingTime,
    required int servings,
  }) async {
    try {
      final recipe = Recipe(
        name: name,
        imageUrl: imageUrl,
        description: description,
        cookingSteps: cookingSteps,
        cookingTime: cookingTime,
        servings: servings,
      );
      await _repository.addRecipe(recipe);
      emit(RecipeOperationSuccess('Recipe added successfully'));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> updateRecipe({
    required String id,
    required String name,
    required String imageUrl,
    required String description,
    required List<String> cookingSteps,
    required int cookingTime,
    required int servings,
  }) async {
    try {
      final recipe = Recipe(
        id: id,
        name: name,
        imageUrl: imageUrl,
        description: description,
        cookingSteps: cookingSteps,
        cookingTime: cookingTime,
        servings: servings,
      );
      await _repository.updateRecipe(recipe);
      emit(RecipeOperationSuccess('Recipe updated successfully'));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      await _repository.deleteRecipe(id);
      emit(RecipeOperationSuccess('Recipe deleted successfully'));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> addSampleRecipes() async {
    try {
      await _repository.addSampleRecipes();
      emit(RecipeOperationSuccess('Sample recipes added successfully'));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
}
