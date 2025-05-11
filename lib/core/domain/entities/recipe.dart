class Recipe {
  final String? id;
  final String name;
  final String imageUrl;
  final String description;
  final List<String> cookingSteps;
  final int cookingTime;
  final int servings;
  final int progress;

  Recipe({
    this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.cookingSteps,
    required this.cookingTime,
    required this.servings,
    this.progress = 0,
  });

  Recipe copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? description,
    List<String>? cookingSteps,
    int? cookingTime,
    int? servings,
    int? progress,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      cookingSteps: cookingSteps ?? this.cookingSteps,
      cookingTime: cookingTime ?? this.cookingTime,
      servings: servings ?? this.servings,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'cookingSteps': cookingSteps,
      'cookingTime': cookingTime,
      'servings': servings,
      'progress': progress,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json, String id) {
    return Recipe(
      id: id,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      cookingSteps: List<String>.from(json['cookingSteps'] as List),
      cookingTime: json['cookingTime'] as int,
      servings: json['servings'] as int,
      progress: json['progress'] as int? ?? 0,
    );
  }
}
