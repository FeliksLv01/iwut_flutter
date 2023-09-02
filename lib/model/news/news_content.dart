import 'dart:convert';

class NewsContent {
  NewsContent({
    this.id,
    this.fKId,
    this.postItem,
    this.content,
  });

  int? id;
  int? fKId;
  dynamic postItem;
  String? content;

  factory NewsContent.fromRawJson(String str) => NewsContent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewsContent.fromJson(Map<String, dynamic> json) => NewsContent(
        id: json["id"],
        fKId: json["fK_Id"],
        postItem: json["postItem"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fK_Id": fKId,
        "postItem": postItem,
        "content": content,
      };
}
