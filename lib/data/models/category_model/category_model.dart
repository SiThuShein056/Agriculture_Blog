class CategoryModel {
  final String id;
  final String name;
  final String mainCategoryID;

  CategoryModel({
    required this.id,
    required this.name,
    required this.mainCategoryID,
  });

  @override
  bool operator ==(covariant CategoryModel other) {
    // TODO: implement ==
    return other.id == id;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mainCategory_id": mainCategoryID,
      };

  factory CategoryModel.fromJson(dynamic data) {
    return CategoryModel(
      id: data["id"],
      name: data["name"],
      mainCategoryID: data["mainCategory_id"],
    );
  }
}
