class News {
  String id;
  String guid;
  int publishedOn;
  String imageurl;
  String title;
  String url;
  String source;
  String body;
  String tags;
  String categories;
  String upvotes;
  String downvotes;

  News({
    this.id,
    this.guid,
    this.publishedOn,
    this.imageurl,
    this.title,
    this.url,
    this.source,
    this.body,
    this.tags,
    this.categories,
    this.upvotes,
    this.downvotes,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json["id"],
    guid: json["guid"],
    publishedOn: json["published_on"],
    imageurl: json["imageurl"],
    title: json["title"],
    url: json["url"],
    source: json["source"],
    body: json["body"],
    tags: json["tags"],
    categories: json["categories"],
    upvotes: json["upvotes"],
    downvotes: json["downvotes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "guid": guid,
    "published_on": publishedOn,
    "imageurl": imageurl,
    "title": title,
    "url": url,
    "source": source,
    "body": body,
    "tags": tags,
    "categories": categories,
    "upvotes": upvotes,
    "downvotes": downvotes,
  };
}