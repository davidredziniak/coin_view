import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'apimanager.dart';
import 'coin.dart';
import 'package:http/http.dart' as http;
String JsonContent = "";

void main () async{
  runApp(MaterialApp(
    home: MyListScreen(),
  ));
  print('Hello');
  // produces a request object

}

List<Coin> coins = new List<Coin>();


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

class MyListScreen extends StatefulWidget {
  @override
  createState() => _MyListScreenState();
}

class _MyListScreenState extends State {

  //Populates the Top 25 coins list.
  _getUsers() {
    ApiManager.getTop25().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        coins = list.map((model) => Coin.fromJson(model)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _getUsers();
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: (
            IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh values',
              onPressed: (){
                _getUsers(); //Refresh list by calling ApiManager
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
      body: SingleChildScrollView(
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
              tooltip: 'Market capitilization rank',
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
          rows: coins.map((coinObj) => DataRow(
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
      ),
    );
  }
}
