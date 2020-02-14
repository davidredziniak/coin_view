import 'dart:async';
import 'package:http/http.dart' as http;

class ApiManager {

  //Using CoinGecko API, retrieve top 25 coins
  static Future getTop25() {
    String url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=25&page=1&sparkline=false";
    return http.get(url);
  }

  static Future getNewsInfoLatest(){
    String url = "https://min-api.cryptocompare.com/data/v2/news/?lang=EN&sortOrder=latest";
    return http.get(url);
  }

  static Future getNewsInfoPopular(){
    String url = "https://min-api.cryptocompare.com/data/v2/news/?feeds=cryptocompare,cointelegraph,coindesk";
    return http.get(url);
  }
}