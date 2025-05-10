import 'package:flutter/material.dart';

class RecipeInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const RecipeInfoItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(title),
      ],
    );
  }
}
