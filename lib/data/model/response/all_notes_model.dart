import 'dart:convert';

class AllNotesResponseModel {
  final String? message;
  final List<Datum>? data;

  AllNotesResponseModel({
    this.message,
    this.data,
  });

  factory AllNotesResponseModel.fromJson(String str) => AllNotesResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AllNotesResponseModel.fromMap(Map<String, dynamic> json) => AllNotesResponseModel(
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class Datum {
  final int? id;
  final String? title;
  final String? content;
  final String? image;
  final int? isPinned;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Datum({
    this.id,
    this.title,
    this.content,
    this.image,
    this.isPinned,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    image: json["image"],
    isPinned: json["is_pinned"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "content": content,
    "image": image,
    "is_pinned": isPinned,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
