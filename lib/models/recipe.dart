class Recipe {
  final int? id;
  final String name;
  final String type;
  final String imagePath;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    this.id,
    required this.name,
    required this.type,
    required this.imagePath,
    required this.ingredients,
    required this.steps,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'imagePath': imagePath,
      'ingredients': ingredients.join(','),
      'steps': steps.join(','),
    };
  }

  static Recipe fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      imagePath: json['imagePath'],
      ingredients: (json['ingredients'] as String).split(','),
      steps: (json['steps'] as String).split(','),
    );
  }
}
