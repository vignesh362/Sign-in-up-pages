// To parse this JSON data, do
//
//     final otpverify = otpverifyFromJson(jsonString);

import 'dart:convert';

Otpverify otpverifyFromJson(String str) => Otpverify.fromJson(json.decode(str));

String otpverifyToJson(Otpverify data) => json.encode(data.toJson());

class Otpverify {
  Otpverify({
    this.message,
    this.token,
  });

  String message;
  String token;

  factory Otpverify.fromJson(Map<String, dynamic> json) => Otpverify(
    message: json["message"],
    token: json["token"]==null?null:json["token"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": token,
  };
}
