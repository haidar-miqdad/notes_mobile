import 'dart:convert';

class NotesResponseModel {
  final String? message;
  final Note? data;

  NotesResponseModel({
    this.message,
    this.data,
  });

  factory NotesResponseModel.fromJson(String str) => NotesResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotesResponseModel.fromMap(Map<String, dynamic> json) => NotesResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : Note.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "message": message,
    "data": data?.toMap(),
  };
}

class Note {
  final String? title;
  final String? content;
  final String? isPinned;
  final String? image;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  Note({
    this.title,
    this.content,
    this.isPinned,
    this.image,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Note.fromJson(String str) => Note.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Note.fromMap(Map<String, dynamic> json) => Note(
    title: json["title"],
    content: json["content"],
    isPinned: json["is_pinned"],
    image: json["image"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "content": content,
    "is_pinned": isPinned,
    "image": image,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
