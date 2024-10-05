class Recipe {
  final int id;
  final String name;
  final String type;
  final String image;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.ingredients,
    required this.steps,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'image': image,
        'ingredients': ingredients,
        'steps': steps,
      };

  static Recipe fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      image: json['image'],
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
    );
  }
}
