import 'package:easy_recipe/core/domain/entities/recipe.dart';

abstract class RecipeRepository {
  Stream<List<Recipe>> getRecipes();
  Future<void> addRecipe(Recipe recipe);
  Future<void> updateRecipe(Recipe recipe);
  Future<void> deleteRecipe(String id);
  Future<void> addSampleRecipes();
}
