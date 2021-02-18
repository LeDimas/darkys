// To parse this JSON data, do
//
//     final member = memberFromJson(jsonString);

import 'dart:convert';

Member memberFromJson(String str) => Member.fromJson(json.decode(str));

String memberToJson(Member data) => json.encode(data.toJson());

class Member {
  Member({
    this.avatarUrl,
    this.name,
    this.email,
    this.section,
  });
  String avatarUrl;
  String name;
  String email;
  List<dynamic> section;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        name: json["name"],
        email: json["email"],
        section: json["section"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "section": section,
      };
}
