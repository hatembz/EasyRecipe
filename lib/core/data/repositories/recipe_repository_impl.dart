import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_recipe/core/domain/entities/recipe.dart';
import 'package:easy_recipe/core/domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'recipes';

  RecipeRepositoryImpl(this._firestore);

  @override
  Stream<List<Recipe>> getRecipes() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recipe.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Future<void> addRecipe(Recipe recipe) async {
    await _firestore.collection(_collection).add(recipe.toJson());
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async {
    if (recipe.id == null) throw Exception('Recipe ID is required for update');
    await _firestore.collection(_collection).doc(recipe.id).update(recipe.toJson());
  }

  @override
  Future<void> deleteRecipe(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  @override
  Future<void> addSampleRecipes() async {
    final sampleRecipes = [
      Recipe(
        name: 'Classic Spaghetti Carbonara',
        imageUrl: 'https://example.com/carbonara.jpg',
        description: 'A classic Italian pasta dish with eggs, cheese, pancetta, and black pepper.',
        cookingSteps: ['Boil pasta in salted water until al dente', 'Fry pancetta until crispy', 'Mix eggs and cheese', 'Combine all ingredients and serve hot'],
        cookingTime: 30,
        servings: 4,
      ),
      // Add more sample recipes here
    ];

    for (final recipe in sampleRecipes) {
      await addRecipe(recipe);
    }
  }
}
