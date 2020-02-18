import 'package:flutter/material.dart';
import 'coin.dart';
import 'api_manager.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';


class CoinPage extends StatefulWidget {
  @override
  _CoinPageState createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  Future<List<Coin>> _coins;
  int _column = 0;
  bool _sortAscending = true;

  @override
  void initState(){
    _coins = getList();
    super.initState();
  }

  Future<List<Coin>> getList() async {
    List<Coin> tempList = new List<Coin>();
    ApiManager.getTop25().then((response) {
      setState(() {
        var parsedList = json.decode(response.body);
        var ll = (parsedList as List).map((data) => new Coin.fromJson(data)).toList();
        for(Coin c in ll){
          tempList.add(c);
        }
      });
    });
    return tempList;
  }

  TextStyle getTextStyle(double number){
    if(number < 0){
      return TextStyle(
        color: Colors.red,
      );
    }
    else if(number == 0){
      return TextStyle(
        color: Colors.black,
      );
    }
    else{
      return TextStyle(
        color: Colors.green[600],
      );
    }
  }


  void toggle(int columnIndex){
    setState(() {
      _column = columnIndex;
      _sortAscending = !_sortAscending;
    });
  }

  Widget getCoinList(List<Coin> coinList){
    if(coinList.isEmpty)
      return new Container();


    /*
      Sorted
     */
    switch(_column){
      case 0:
        if(_sortAscending)
          coinList.sort((a,b) => a.getRank().compareTo(b.getRank()));
        else
          coinList.sort((a,b) => b.getRank().compareTo(a.getRank()));
        break;
      case 1:
        if(_sortAscending)
          coinList.sort((a,b) => a.getName().compareTo(b.getName()));
        else
          coinList.sort((a,b) => b.getName().compareTo(a.getName()));
        break;
      case 2:
        if(_sortAscending)
          coinList.sort((a,b) => a.getPrice().compareTo(b.getPrice()));
        else
          coinList.sort((a,b) => b.getPrice().compareTo(a.getPrice()));
        break;
      case 3:
        if(_sortAscending)
          coinList.sort((a,b) => a.getPercentChange().compareTo(b.getPercentChange()));
        else
          coinList.sort((a,b) => b.getPercentChange().compareTo(a.getPercentChange()));
        break;
      default:
        coinList.sort((a,b) => a.getRank().compareTo(b.getRank()));
    }

    return SingleChildScrollView(
      child: DataTable(
        sortAscending: _sortAscending,
        sortColumnIndex: _column,
        dataRowHeight: 50,
        columns: [
          DataColumn(
            label: Container(
              child: Text('',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
            onSort: (columnNumber, isAscending){
              toggle(columnNumber);
            },
            numeric: true,
          ),
          DataColumn(
            label: Text('Name',
                style: TextStyle(
                  color: Colors.white,
                )),
            numeric: false,
            tooltip: 'Coin name',
            onSort: (columnNumber, isAscending){
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
            onSort: (columnNumber, isAscending){
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
            onSort: (columnNumber, isAscending){
              toggle(columnNumber);
            },
          ),
        ],
        rows: coinList.map((coinObj) => DataRow(
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
              Text(coinObj.getName(), style: TextStyle(color: Colors.white),),
            ),
            DataCell(
              Text(coinObj.getPrice().toStringAsFixed(2), style: TextStyle(color: Colors.white),),
            ),
            DataCell(
              Container(
                child: Text(
                  coinObj.getPercentChange().toStringAsFixed(2),
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
                _coins = getList();
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
        future: _coins,
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return Container();
            case ConnectionState.waiting:
              return getCoinList([]);
              break;
            default:
              while(snapshot.data.isEmpty){
                return Container(child: Text('Loading..'),);
              }
              if(snapshot.hasError)
                return Container(child: Text('ERROR FOUND'));
              return getCoinList(snapshot.data);
          }
        },
      ),
    );
  }
}