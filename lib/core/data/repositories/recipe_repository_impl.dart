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
    try {
      await _firestore.collection(_collection).add(recipe.toJson());
    } catch (e) {
      throw Exception('Failed to add recipe: $e');
    }
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
        imageUrl: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1771&q=80',
        description: 'A classic Italian pasta dish with eggs, cheese, pancetta, and black pepper.',
        cookingSteps: ['Boil pasta in salted water until al dente', 'Fry pancetta until crispy', 'Mix eggs and cheese', 'Combine all ingredients and serve hot'],
        cookingTime: 30,
        servings: 4,
      ),
      Recipe(
        name: 'Homemade Margherita Pizza',
        imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1770&q=80',
        description: 'Classic Neapolitan pizza with fresh mozzarella, tomatoes and basil.',
        cookingSteps: ['Make pizza dough and let rise', 'Prepare tomato sauce', 'Roll out dough and add toppings', 'Bake in very hot oven until crust is crispy'],
        cookingTime: 45,
        servings: 2,
      ),
      Recipe(
        name: 'Thai Green Curry',
        imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1770&q=80',
        description: 'Fragrant coconut curry with vegetables and your choice of protein.',
        cookingSteps: ['Sauté curry paste in oil', 'Add coconut milk and bring to simmer', 'Add vegetables and protein', 'Cook until done and serve with rice'],
        cookingTime: 40,
        servings: 4,
      ),
      Recipe(
        name: 'Classic French Omelette',
        imageUrl: 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1674&q=80',
        description: 'Light and fluffy French-style omelette with fresh herbs.',
        cookingSteps: ['Beat eggs with herbs and seasoning', 'Heat butter in non-stick pan', 'Add eggs and stir gently', 'Roll into classic omelette shape'],
        cookingTime: 15,
        servings: 1,
      )
    ];

    for (final recipe in sampleRecipes) {
      await addRecipe(recipe);
    }
  }
}
