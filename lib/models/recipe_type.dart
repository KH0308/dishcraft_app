class RecipeType {
  final int id;
  final String type;

  RecipeType({required this.id, required this.type});

  factory RecipeType.fromJson(Map<String, dynamic> json) {
    return RecipeType(
      id: json['id'],
      type: json['type'],
    );
  }
}
