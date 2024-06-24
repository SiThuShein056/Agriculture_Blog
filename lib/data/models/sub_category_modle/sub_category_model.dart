import 'package:equatable/equatable.dart';

class SubCategoryModel extends Equatable {
  final String id;
  final String category_id;
  final String name;

  const SubCategoryModel({
    required this.id,
    required this.category_id,
    required this.name,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id];

  factory SubCategoryModel.fromJson(dynamic data) {
    return SubCategoryModel(
      id: data["id"],
      category_id: data["category_id"],
      name: data["name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": category_id,
        "name": name,
      };
}
