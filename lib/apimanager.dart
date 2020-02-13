import 'dart:async';
import 'package:http/http.dart' as http;

String baseUrl = "https://api.coingecko.com/api/v3";

class ApiManager {

  static Future getTop25() {
    //Using CoinGecko API, retrieve top 25 coins
    String url = baseUrl + "/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=25&page=1&sparkline=false";
    return http.get(url);
  }

}