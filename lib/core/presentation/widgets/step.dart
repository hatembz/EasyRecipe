import 'package:easy_recipe/core/domain/entities/recipe.dart';
import 'package:easy_recipe/core/presentation/cubits/recipe_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StepPageView extends StatefulWidget {
  final Recipe recipe;

  const StepPageView({super.key, required this.recipe});

  @override
  State<StepPageView> createState() => _StepPageViewState();
}

class _StepPageViewState extends State<StepPageView> {
  late final PageController _pageController;
  late int _currentStep;

  @override
  void initState() {
    super.initState();
    // Initialize with the recipe's progress
    _currentStep = widget.recipe.progress;
    _pageController = PageController(initialPage: _currentStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _trackStepProgress() async {
    if (!mounted) return;
    try {
      await context.read<RecipeCubit>().trackStepProgress(
            recipeId: widget.recipe.id ?? '',
            currentStep: _currentStep,
            totalSteps: widget.recipe.cookingSteps.length,
          );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to track progress: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.recipe.cookingSteps.length,
            onPageChanged: (index) {
              setState(() => _currentStep = index);
              _trackStepProgress();
            },
            itemBuilder: (context, index) {
              final step = widget.recipe.cookingSteps[index];
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step ${index + 1}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _currentStep > 0
                  ? () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      )
                  : null,
            ),
            Text('Step ${_currentStep + 1} of ${widget.recipe.cookingSteps.length}'),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: _currentStep < widget.recipe.cookingSteps.length - 1
                  ? () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      )
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
