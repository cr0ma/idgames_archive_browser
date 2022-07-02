// To parse this JSON data, do
//
//     final contents = contentsFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

class Contents {
  Contents({
    required this.content,
    required this.meta,
  });

  Content content;
  Meta meta;

  factory Contents.fromRawJson(String str) =>
      Contents.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Contents.fromJson(Map<String, dynamic> json) => Contents(
        content: Content.fromJson(json["content"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content.toJson(),
        "meta": meta.toJson(),
      };
}

class Content {
  Content({
    required this.file,
  });

  List<FileElement> file;

  factory Content.fromRawJson(String str) => Content.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        file: List<FileElement>.from(
            json["file"].map((x) => FileElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "file": List<dynamic>.from(file.map((x) => x.toJson())),
      };
}

class FileElement {
  FileElement({
    required this.id,
    required this.title,
    required this.dir,
    required this.filename,
    required this.size,
    required this.age,
    required this.date,
    // required this.author,
    // required this.email,
    // required this.description,
    required this.rating,
    required this.votes,
    required this.url,
    required this.idgamesurl,
  });

  int id;
  String title;
  String dir;
  String filename;
  int size;
  int age;
  DateTime date;
  // String author;
  // String email;
  // String description;
  double rating;
  int votes;
  String url;
  String idgamesurl;

  factory FileElement.fromRawJson(String str) =>
      FileElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        id: json["id"],
        title: json["title"],
        dir: json["dir"],
        filename: json["filename"],
        size: json["size"],
        age: json["age"],
        date: DateTime.parse(json["date"]),
        // author: json["author"],
        // email: json["email"] == null ? null : json["email"],
        // description: json["description"],
        rating: json["rating"].toDouble(),
        votes: json["votes"],
        url: json["url"],
        idgamesurl: json["idgamesurl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "dir": dir,
        "filename": filename,
        "size": size,
        "age": age,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        // "author": author,
        // "email": email == null ? null : email,
        // "description": description,
        "rating": rating,
        "votes": votes,
        "url": url,
        "idgamesurl": idgamesurl,
      };
}

class Meta {
  Meta({
    required this.version,
  });

  int version;

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        version: json["version"],
      );

  Map<String, dynamic> toJson() => {
        "version": version,
      };
}
