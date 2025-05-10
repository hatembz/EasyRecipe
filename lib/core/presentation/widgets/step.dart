import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class StepPageView extends StatefulWidget {
  final String recipeId;
  final List<String> steps;

  const StepPageView({
    super.key,
    required this.recipeId,
    required this.steps,
  });

  @override
  State<StepPageView> createState() => StepPageViewState();
}

class StepPageViewState extends State<StepPageView> {
  int _currentPage = 0;
  late final PageController _controller;
  final _functions = FirebaseFunctions.instance;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _trackStepProgress(int step) async {
    try {
      debugPrint('Tracking step progress: ${step + 1}/${widget.steps.length} for recipe ${widget.recipeId}');
      final result = await _functions.httpsCallable('trackRecipeStep').call({
        'recipeId': widget.recipeId,
        'currentStep': step + 1,
        'totalSteps': widget.steps.length,
      });
      debugPrint('Step progress tracked successfully: ${result.data}');
    } catch (e, stackTrace) {
      debugPrint('Failed to track step progress: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.steps.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              _trackStepProgress(index);
            },
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.steps[index],
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
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
              onPressed: _currentPage > 0
                  ? () => _controller.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      )
                  : null,
            ),
            Text('Step ${_currentPage + 1} of ${widget.steps.length}'),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: _currentPage < widget.steps.length - 1
                  ? () => _controller.nextPage(
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
