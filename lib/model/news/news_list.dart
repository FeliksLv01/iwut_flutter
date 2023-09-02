import 'dart:convert';

class NewsListModel {
  List<NewsModel> NewsList;

  NewsListModel(this.NewsList);

  factory NewsListModel.fromJson(List<dynamic> parseJson) {
    List<NewsModel> NewsList;
    NewsList = parseJson.map((e) => NewsModel.fromJson(e)).toList();
    return NewsListModel(NewsList);
  }
}

class NewsModel {
  NewsModel({
    this.id,
    this.postId,
    this.title,
    this.source,
    this.originUrl,
    this.publishDate,
    this.postDetails,
  });

  int? id;
  String? postId;
  String? title;
  String? source;
  String? originUrl;
  int? publishDate;
  dynamic postDetails;

  factory NewsModel.fromRawJson(String str) => NewsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json["id"],
        postId: json["postId"],
        title: json["title"],
        source: json["source"],
        originUrl: json["originUrl"],
        publishDate: json["publishDate"],
        postDetails: json["postDetails"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "postId": postId,
        "title": title,
        "source": source,
        "originUrl": originUrl,
        "publishDate": publishDate,
        "postDetails": postDetails,
      };
}
