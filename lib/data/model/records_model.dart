// To parse this JSON data, do
//
//     final recordsModel = recordsModelFromMap(jsonString);

import 'dart:convert';

import 'package:fs_manager/data/my_encryption.dart';

RecordModel recordsModelFromMap(String str) =>
    RecordModel.fromMap(json.decode(str));

String recordsModelToMap(RecordModel data) => json.encode(data.toMap());

class RecordModel {
  RecordModel({
    required this.logoValue,
    required this.password,
    required this.name,
    required this.tag,
    required this.webSite,
    required this.username,
  });

  final String logoValue;
  final String password;
  final String name;
  final List<String> tag;
  final String webSite;
  final String username;

  factory RecordModel.fromMap(Map<dynamic, dynamic> json) {
    return RecordModel(
      logoValue: json["logoValue"],
      password: json["password"],
      name: json["name"],
      tag: List<String>.from(json["tag"].map((x) => x)),
      webSite: json["web_site"],
      username: json["username"],
    );
  }

  Map<String, dynamic> toMap() => {
        "logoValue": logoValue,
        "password": password,
        "name": name,
        "tag": List<dynamic>.from(tag.map((x) => x)),
        "web_site": webSite,
        "username": username,
      };
}

class AccountRec {
  final String id;
  final RecordModel model;
  AccountRec({
    required this.id,
    required this.model,
  });
}
