import 'dart:convert';

import 'package:honey_cook/base/base_codable.dart';

class ApiModel extends Encodable {
  final userId = Interger(key: 'userId');
  final id = Interger(key: 'id');
  final title = Stringer(key: 'title');
  final body = Stringer(key: 'body');

  @override
  List<OriginalCodable> properties() {
    return [userId,id,title,body];
  }

  // ApiModel({required this.userId, required this.id, required this.title, required this.body});
  //
  // Map<String, dynamic> toJson() => {
  //   'userId': userId,
  //   'id': id,
  //   'title': title,
  //   'body': body
  // };
  //
  // factory ApiModel.fromJson(Map<String, dynamic> json) => ApiModel(userId: json['userId'], id: json['id'], title: json['title'], body: json['body']);
}

// List<ApiModel> postFromJson(String str) => List<ApiModel>.from(json.decode(str).map((x) => ApiModel.fromJson(x)));
// String postToJson(List<ApiModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));