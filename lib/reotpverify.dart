//
//     final reotpverify = reotpverifyFromJson(jsonString);

import 'dart:convert';

Reotpverify reotpverifyFromJson(String str) => Reotpverify.fromJson(json.decode(str));

String reotpverifyToJson(Reotpverify data) => json.encode(data.toJson());

class Reotpverify {
  Reotpverify({
    this.message,
  });

  String message;

  factory Reotpverify.fromJson(Map<String, dynamic> json) => Reotpverify(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
