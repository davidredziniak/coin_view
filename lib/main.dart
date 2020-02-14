import 'package:flutter/material.dart';
import 'coin_page.dart';
import 'news_page.dart';

void main () async{
  runApp(MaterialApp(
    home: MyListScreen(),
  ));
}


class MyListScreen extends StatefulWidget {
  @override
  createState() => _MyListScreenState();
}



class _MyListScreenState extends State {
  int _currentState = 0;
  final bodyList = [FirstPage(), NewsPage()];

  void _onItemTapped(int index) {
    setState(() {
      _currentState = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyList[_currentState],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            title: Text('News'),
          ),
        ],
        currentIndex: _currentState,
        backgroundColor: Colors.grey[850],
        selectedItemColor: Colors.yellowAccent,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
