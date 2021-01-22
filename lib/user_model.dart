// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.message,
    this.userId,
  });

  String message;
  String userId;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    message: json["message"],
    userId: json["userId"]==null?123:json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "userId": userId==null?123:userId,
  };
}
