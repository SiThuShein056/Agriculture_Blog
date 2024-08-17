class MainCategoryModel {
  final String id;
  final String name;

  MainCategoryModel({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(covariant MainCategoryModel other) {
    // TODO: implement ==
    return other.id == id;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  factory MainCategoryModel.fromJson(dynamic data) {
    return MainCategoryModel(
      id: data["id"],
      name: data["name"],
    );
  }
}
