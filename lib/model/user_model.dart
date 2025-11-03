// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? accessToken;
  String? refreshToken;
  User? user;

  UserModel({this.accessToken, this.refreshToken, this.user});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(accessToken: json["accessToken"], refreshToken: json["refreshToken"], user: json["user"] == null ? null : User.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {"accessToken": accessToken, "refreshToken": refreshToken, "user": user?.toJson()};
}

class User {
  String? username;
  String? email;
  String? role; // "Employee" or "User"
  String? id;
  DateTime? createdAt;
  String? profilePicture;
  String? walletId;
  Company? company; // <--- only present when role == "Employee"

  User({this.username, this.email, this.role, this.id, this.createdAt, this.profilePicture, this.walletId, this.company});

  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json["username"],
    email: json["email"],
    role: json["role"],
    id: json["_id"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    profilePicture: json["profilePicture"],
    walletId: json["walletID"],
    company: json["company"] == null ? null : Company.fromJson(json["company"]),
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "role": role,
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
    "profilePicture": profilePicture,
    "walletID": walletId,
    "company": company?.toJson(),
  };

  bool get isEmployee => (role ?? '').toLowerCase() == 'employee';
  bool get isUser => (role ?? '').toLowerCase() == 'user';
}

class Company {
  String? id;
  String? username;
  String? registrationNo;
  String? email;
  String? role;
  String? refreshToken;
  String? profilePicture;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Company({this.id, this.username, this.registrationNo, this.email, this.role, this.refreshToken, this.profilePicture, this.status, this.createdAt, this.updatedAt});

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["_id"],
    username: json["username"],
    registrationNo: json["registrationNo"],
    email: json["email"],
    role: json["role"],
    refreshToken: json["refreshToken"],
    profilePicture: json["profilePicture"],
    status: json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "registrationNo": registrationNo,
    "email": email,
    "role": role,
    "refreshToken": refreshToken,
    "profilePicture": profilePicture,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
