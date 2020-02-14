import 'package:flutter/material.dart';
import 'coin.dart';
import 'api_manager.dart';
import 'dart:convert';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Future<List<Coin>> _coins;

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

  SingleChildScrollView getCoinList(List<Coin> snapshot){
    return SingleChildScrollView(
      child: DataTable(
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
            numeric: true,
          ),
          DataColumn(
            label: Text('Name',
                style: TextStyle(
                  color: Colors.white,
                )),
            numeric: false,
            tooltip: 'Coin name',
          ),
          DataColumn(
            label: Text('Price',
                style: TextStyle(
                  color: Colors.white,
                )),
            numeric: true,
            tooltip: 'Current price of coin',
          ),
          DataColumn(
            label: Text('%',
                style: TextStyle(
                  color: Colors.white,
                )),
            numeric: true,
            tooltip: 'Price change in 24 hours',
          ),
        ],
        rows: snapshot.map((coinObj) => DataRow(
          cells: [
            DataCell(
              Tab(icon: IconButton(
                icon: new Image.asset(
                  'assets/' + coinObj.getId() + '.png',
                  height: 25,),
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

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: (
            IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh news',
              onPressed: (){
                setState(() {
                  _coins = getList();
                });
              },
            )
        ),
        title: Text('Coin View'),
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