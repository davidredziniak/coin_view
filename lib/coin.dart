class Coin{

  String _name;
  double _price;
  int _rank;
  double _percentChange;
  String _id;

  Coin(String name, int rank, double price, double percentChange, String id){
    _name = name;
    _rank = rank;
    _price = price;
    _percentChange = percentChange;
    _id = id;
  }

  //Getters
  int getRank() => _rank;
  String getName() => _name;
  double getPrice() => _price;
  double getPercentChange() => _percentChange;
  String getId() => _id;

  Coin.fromJson(Map json) : _name = json['name'], _price = json['current_price'], _rank = json['market_cap_rank'], _percentChange = json['price_change_percentage_24h'], _id = json['id'];
}