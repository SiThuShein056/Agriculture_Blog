class PostModel {
  final String id;
  final String userId;
  final String createdAt;
  final String category;
  final String image;
  final String description;

  PostModel({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.category,
    required this.image,
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
        "createdAt": createdAt,
        "category": category,
        "image": image,
        "description": description,
      };

  factory PostModel.fromJson(dynamic data) {
    return PostModel(
      id: data["id"],
      userId: data["userId"],
      createdAt: data["createdAt"],
      category: data["category"],
      image: data["image"],
      description: data["description"],
    );
  }
}
