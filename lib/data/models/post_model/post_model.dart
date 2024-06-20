class PostModel {
  final String id;
  final String userId;
  final String category;
  final String description;

  PostModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.description,
  });

  @override
  bool operator ==(covariant PostModel other) {
    // TODO: implement ==
    return other.id == id;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "category": category,
        "description": description,
      };

  factory PostModel.fromJson(dynamic data) {
    return PostModel(
      id: data["id"],
      userId: data["userId"],
      category: data["category"],
      description: data["description"],
    );
  }
}
