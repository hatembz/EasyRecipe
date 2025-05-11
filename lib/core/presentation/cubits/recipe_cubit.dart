import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_recipe/core/domain/entities/recipe.dart';
import 'package:easy_recipe/core/domain/repositories/recipe_repository.dart';
import 'package:easy_recipe/core/presentation/cubits/recipe_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final RecipeRepository _repository;
  final FirebaseFunctions _functions;

  RecipeCubit(this._repository)
      : _functions = FirebaseFunctions.instance,
        super(RecipeInitial()) {
    loadRecipes();
  }
  List<Recipe> recipes = [];

  Future<void> loadRecipes() async {
    emit(RecipeLoading());
    try {
      await for (final recipes in _repository.getRecipes()) {
        this.recipes = recipes;
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

  Future<void> trackStepProgress({
    required String recipeId,
    required int currentStep,
    required int totalSteps,
  }) async {
    try {
      final result = await _functions.httpsCallable('trackRecipeStep').call({
        'recipeId': recipeId,
        'currentStep': currentStep,
        'totalSteps': totalSteps,
      });
      log(result.data.toString());
      if (result.data['success']) {
        emit(StepTrackingSuccess(
          recipeId: recipeId,
          currentStep: currentStep,
          totalSteps: totalSteps,
        ));
      } else {
        throw Exception(result.data['error']);
      }
    } catch (e) {
      emit(RecipeError('Failed to track step progress: ${e.toString()}'));
    }
  }
}
