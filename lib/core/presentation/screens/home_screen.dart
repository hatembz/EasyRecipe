import 'package:easy_recipe/core/domain/entities/recipe.dart';
import 'package:easy_recipe/core/presentation/cubits/recipe_cubit.dart';
import 'package:easy_recipe/core/presentation/cubits/recipe_state.dart';
import 'package:easy_recipe/core/presentation/screens/recipe_details_screen.dart';
import 'package:easy_recipe/core/presentation/screens/recipe_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Easy Recipe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<RecipeCubit>().addSampleRecipes();
            },
            tooltip: 'Add Sample Recipes',
          ),
        ],
      ),
      body: BlocBuilder<RecipeCubit, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is RecipeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RecipeCubit>().loadRecipes();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is RecipeLoaded) {
            if (state.recipes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No recipes found',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<RecipeCubit>().addSampleRecipes();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Add Sample Recipes'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.recipes.length,
              itemBuilder: (context, index) {
                final recipe = state.recipes[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailsScreen(
                            recipe: recipe,
                          ),
                        ),
                      );
                    },
                    onLongPress: () => _editRecipe(context, recipe),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                          child: Image.network(
                            recipe.imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.error_outline,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.name,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                recipe.description,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.timer, size: 16),
                                  const SizedBox(width: 4),
                                  Text('${recipe.cookingTime} mins'),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.people, size: 16),
                                  const SizedBox(width: 4),
                                  Text('${recipe.servings} servings'),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.format_list_numbered, size: 16),
                                  const SizedBox(width: 4),
                                  Text('${recipe.cookingSteps.length} steps'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addRecipe(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addRecipe(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecipeFormScreen()),
    );

    if (result is Recipe) {
      context.read<RecipeCubit>().addRecipe(
            name: result.name,
            imageUrl: result.imageUrl,
            description: result.description,
            cookingSteps: result.cookingSteps,
            cookingTime: result.cookingTime,
            servings: result.servings,
          );
    }
  }

  Future<void> _editRecipe(BuildContext context, Recipe recipe) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeFormScreen(recipe: recipe),
      ),
    );

    if (result == 'delete') {
      context.read<RecipeCubit>().deleteRecipe(recipe.id ?? '');
    } else if (result is Recipe) {
      context.read<RecipeCubit>().updateRecipe(
            id: recipe.id ?? '',
            name: result.name,
            imageUrl: result.imageUrl,
            description: result.description,
            cookingSteps: result.cookingSteps,
            cookingTime: result.cookingTime,
            servings: result.servings,
          );
    }
  }
}
