import 'dart:convert';
import 'news.dart';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  int type;
  String message;
  List<dynamic> promoted;
  List<News> data;
  RateLimit rateLimit;
  bool hasWarning;

  Welcome({
    this.type,
    this.message,
    this.promoted,
    this.data,
    this.rateLimit,
    this.hasWarning,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    type: json["Type"],
    message: json["Message"],
    promoted: List<dynamic>.from(json["Promoted"].map((x) => x)),
    data: List<News>.from(json["Data"].map((x) => News.fromJson(x))),
    rateLimit: RateLimit.fromJson(json["RateLimit"]),
    hasWarning: json["HasWarning"],
  );

  Map<String, dynamic> toJson() => {
    "Type": type,
    "Message": message,
    "Promoted": List<dynamic>.from(promoted.map((x) => x)),
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
    "RateLimit": rateLimit.toJson(),
    "HasWarning": hasWarning,
  };
}

enum Lang { EN }

final langValues = EnumValues({
  "EN": Lang.EN
});

class SourceInfo {
  String name;
  Lang lang;
  String img;

  SourceInfo({
    this.name,
    this.lang,
    this.img,
  });

  factory SourceInfo.fromJson(Map<String, dynamic> json) => SourceInfo(
    name: json["name"],
    lang: langValues.map[json["lang"]],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "lang": langValues.reverse[lang],
    "img": img,
  };
}

class RateLimit {
  RateLimit();

  factory RateLimit.fromJson(Map<String, dynamic> json) => RateLimit(
  );

  Map<String, dynamic> toJson() => {
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
