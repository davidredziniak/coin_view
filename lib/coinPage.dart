import 'package:flutter/material.dart';
import 'Objects/coin.dart';
import 'API/apiManager.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class CoinPage extends StatefulWidget {
  @override
  _CoinPageState createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  Future<List<Coin>> _coinsList;
  int _column = 0;
  bool _sortAscending = true;
  int _columnSelected = 0;

  @override
  void initState(){
    _coinsList = getCoinsList();
    super.initState();
  }

  Future<List<Coin>> getCoinsList() async {
    List<Coin> list = new List<Coin>();
    ApiManager.getTop25().then((response) {
      setState(() {
        var jsonData = json.decode(response.body);
        var parsedCoins = (jsonData as List).map((data) => new Coin.fromJson(data)).toList();
        for(Coin c in parsedCoins){
          list.add(c);
        }
      });
    });
    return list;
  }

  /// Retrieve text color based on percentage increase or decrease
  /// number < 0 -- Red
  /// number > 0 -- Green
  /// number = 0 -- White
  TextStyle getTextStyle(double number){
    Color color;
    color = number > 0 ? Colors.green[600] : number < 0 ? Colors.red : Colors.white;
    return TextStyle(
      color: color,
    );
  }

  /// Toggle the column rows, ascending or descending
  void toggle(int columnIndex){
    setState(() {
      _sortAscending = _columnSelected != columnIndex ? true : !_sortAscending;
      _column = columnIndex;
      _columnSelected = columnIndex;
    });
  }

  String getPercentageString(Coin coinObj){
    if(coinObj.getPercentChange() > 0)
      return '+' + coinObj.getPercentChange().toStringAsFixed(2);
    return coinObj.getPercentChange().toStringAsFixed(2);
  }

  Widget getSortedList(List<Coin> coins){
    if(coins.isEmpty)
      return new Container();

    switch(_column){
      case 0: //Rank
        if(_sortAscending)
          coins.sort((a,b) => a.getRank().compareTo(b.getRank()));
        else
          coins.sort((a,b) => b.getRank().compareTo(a.getRank()));
        break;
      case 1: //Name
        if(_sortAscending)
          coins.sort((a,b) => a.getName().compareTo(b.getName()));
        else
          coins.sort((a,b) => b.getName().compareTo(a.getName()));
        break;
      case 2: //Price
        if(_sortAscending)
          coins.sort((a,b) => a.getPrice().compareTo(b.getPrice()));
        else
          coins.sort((a,b) => b.getPrice().compareTo(a.getPrice()));
        break;
      case 3: //Percent Change
        if(_sortAscending)
          coins.sort((a,b) => a.getPercentChange().compareTo(b.getPercentChange()));
        else
          coins.sort((a,b) => b.getPercentChange().compareTo(a.getPercentChange()));
        break;
      default:
        coins.sort((a,b) => b.getRank().compareTo(a.getRank()));
    }

    return SingleChildScrollView(
      child: DataTable(
        sortAscending: _sortAscending,
        sortColumnIndex: _column,
        dataRowHeight: 50,
        columns: [
          DataColumn(
            label: Container(),
            onSort: (columnNumber, _sortAscending){
              toggle(columnNumber);
            },
          ),
          DataColumn(
            label: Text('Name',
                style: TextStyle(
                  color: Colors.white,
                )),
            numeric: false,
            tooltip: 'Coin name',
            onSort: (columnNumber, _sortAscending){
              toggle(columnNumber);
            },
          ),
          DataColumn(
            label: Text('Price',
                style: TextStyle(
                  color: Colors.white,
                )),
            numeric: true,
            tooltip: 'Current price of coin',
            onSort: (columnNumber, _sortAscending){
              toggle(columnNumber);
            },
          ),
          DataColumn(
            label: Text('%',
                style: TextStyle(
                  color: Colors.white,
                )),
            numeric: true,
            tooltip: 'Price change in 24 hours',
            onSort: (columnNumber, _sortAscending){
              toggle(columnNumber);
            },
          ),
        ],
        rows: coins.map((coinObj) => DataRow(
          selected: false,
          cells: [
            DataCell(
              Tab(icon: IconButton(
                icon: new Image.network(coinObj.getImage(), height: 32),
                onPressed: (){ //Test
                  print(coinObj.getId());
                },
              )),
            ),
            DataCell(
                Text(coinObj.getName(), style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(
                Text(coinObj.getPrice().toStringAsFixed(2), style: TextStyle(color: Colors.white),
              ),
            ),
            DataCell(
              Container(
                child: Text(
                  getPercentageString(coinObj),
                  style: getTextStyle(coinObj.getPercentChange()),
                ),
              ),
            ),
          ],
        )).toList(),
      ),
    );
  }

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: (
            IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh list',
              onPressed: (){
                _coinsList = getCoinsList();
              },
            )
        ),
        title: Text('Coin View',
        style: GoogleFonts.pTMono(
            color: Colors.white,
          fontSize: 23,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: "Search for a specific coin",
            icon: Icon(Icons.search),
            onPressed: () {
              print('Search'); //Not implemented yet
            },
          ),
        ],
        backgroundColor: Colors.grey[850],
      ),
      backgroundColor: Colors.grey[900],
      body: new FutureBuilder<List<Coin>>(
        future: _coinsList,
        builder: (context, coinsRetrieval){
          switch(coinsRetrieval.connectionState){
            case ConnectionState.none:
              return Container();
            case ConnectionState.waiting:
              return getSortedList([]);
              break;
            default:
              while(coinsRetrieval.data.isEmpty){
                return Container(child: Text('Loading..'),);
              }
              if(coinsRetrieval.hasError)
                return Container(child: Text('ERROR FOUND'));
              return getSortedList(coinsRetrieval.data);
          }
        },
      ),
    );
  }
}