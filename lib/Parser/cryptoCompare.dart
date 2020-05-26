import 'dart:convert';
import '../Objects/news.dart';

CryptoNews getParsedNews(String str) => CryptoNews.fromJson(json.decode(str));

class CryptoNews {
  List<News> data;

  CryptoNews({
    this.data,
  });

  factory CryptoNews.fromJson(Map<String, dynamic> json) => CryptoNews(
    data: List<News>.from(json["Data"].map((x) => News.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}