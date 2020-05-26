class Coin{
  String _name;
  double _price;
  int _rank;
  double _percentChange;
  String _id;
  String _imageUrl;

  Coin(String name, int rank, double price, double percentChange, String id, String imageUrl){
    _name = name;
    _rank = rank;
    _price = price;
    _percentChange = percentChange;
    _id = id;
    _imageUrl = imageUrl;
  }

  int getRank() => _rank;
  String getName() => _name;
  double getPrice() => _price;
  double getPercentChange() => _percentChange;
  String getId() => _id;
  String getImage() => _imageUrl;

  Coin.fromJson(Map json) : _name = json['name'], _price = json['current_price'], _rank = json['market_cap_rank'], _percentChange = json['price_change_percentage_24h'], _id = json['id'], _imageUrl = json['image'];
}