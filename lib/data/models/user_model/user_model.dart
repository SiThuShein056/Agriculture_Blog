class UserModel {
  final String id;
  final String name;
  final String email;
  final String profielUrl;
  final String coverUrl;
  final String role;
  bool postStatus, commentStatus, messageStatus, commentPermission;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profielUrl,
    required this.coverUrl,
    this.role = "user",
    required this.messageStatus,
    required this.postStatus,
    required this.commentStatus,
    required this.commentPermission,
  });

  @override
  bool operator ==(covariant UserModel other) {
    // TODO: implement ==
    return other.id == id;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "profileUrl": profielUrl,
        "coverUrl": coverUrl,
        "postStatus": postStatus,
        "commentStatus": commentStatus,
        "messageStatus": messageStatus,
        "commentPermission": commentPermission,
        "role": role,
      };

  factory UserModel.fromJson(dynamic data) {
    return UserModel(
      id: data["id"],
      name: data["name"],
      email: data["email"],
      profielUrl: data["profileUrl"],
      coverUrl: data["coverUrl"],
      role: data["role"],
      postStatus: data["postStatus"],
      commentStatus: data["commentStatus"],
      commentPermission: data["commentPermission"],
      messageStatus: data["messageStatus"],
    );
  }
}

// class UserParam extends DatabaseParamModel {
//   final String id;
//   final String name;
//   final String email;
//   final String profileUrl;

//   const UserParam._({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.profileUrl,
//   });

//   factory UserParam.toCreate({
//     required String id,
//     required String name,
//     required String email,
//     required String profileUrl,
//   }) {
//     return UserParam._(
//       id: id,
//       name: name,
//       email: email,
//       profileUrl: profileUrl,
//     );
//   }

//   factory UserParam.toUpdate({
//     String? id,
//     String? name,
//     String? email,
//     String? profileUrl,
//   }) {
//     return UserParam._(
//       id: id ?? "",
//       name: name ?? "",
//       email: email ?? "",
//       profileUrl: profileUrl ?? "",
//     );
//   }

//   @override
//   Map<String, dynamic> toCreate() {
//     return {
//       "id": id,
//       "name": name,
//       "email": email,
//       "profileUrl": profileUrl,
//     };
//   }

//   @override
//   Map<String, dynamic> toUpdate() {
//     assert(name.isNotEmpty || email.isNotEmpty || profileUrl.isNotEmpty);

//     Map<String, dynamic> payload = {};
//     if (name.isNotEmpty) payload["name"] = name;
//     if (email.isNotEmpty) payload["email"] = email;
//     if (profileUrl.isNotEmpty) payload["profileUrl"] = profileUrl;

//     return payload;
//   }
// }
