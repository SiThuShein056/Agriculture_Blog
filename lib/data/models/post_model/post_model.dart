import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  final String id;
  final String userId;
  final String createdAt;
  final String category;
  final String? phone;
  final String privacy;
  final String description;

  const PostModel({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.category,
    this.phone,
    required this.privacy,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "createdAt": createdAt,
        "category": category,
        "phone": phone,
        "post_type": privacy,
        "description": description,
      };

  factory PostModel.fromJson(dynamic data) {
    return PostModel(
      id: data["id"],
      userId: data["userId"],
      createdAt: data["createdAt"],
      category: data["category"],
      phone: data["phone"],
      privacy: data["post_type"],
      description: data["description"],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
