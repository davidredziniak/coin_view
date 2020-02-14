import 'package:flutter/material.dart';
import 'news.dart';
import 'api_manager.dart';
import 'package:flutter_crypto_viewer/crypto_compare_parser.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}


class _NewsPageState extends State<NewsPage> {
  Future<List<News>> _news;

  @override
  void initState(){
    _news = getList();
    super.initState();
  }

  Future<List<News>> getList() async {
    List<News> tempList = new List<News>();
    ApiManager.getNewsInfoLatest().then((response) {
      setState(() {
        final welcome = welcomeFromJson(response.body);
        for(News n in welcome.data){
          tempList.add(n);
        }
      });
    });
    return tempList;
  }

  Container getNewsContainer(int i, News snap) {
    if(i % 2 == 0){
      return Container(
          alignment: Alignment.centerRight,
          child: Image.network(snap.imageurl,
            height: MediaQuery.of(context).size.height*0.25,
            width: MediaQuery.of(context).size.height*0.25,
          )
      );
    }
    else{
      return Container(
          alignment: Alignment.centerLeft,
          child: Image.network(snap.imageurl,
            height: MediaQuery.of(context).size.height*0.25,
            width: MediaQuery.of(context).size.height*0.25,
          )
      );
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        leading: (
            IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh news',
              onPressed: (){
              setState(() {
                _news = getList();
              });
                },
            )
        ),
        title: Text('Latest News'),
        centerTitle: true,
        actions: <Widget>[
        ],
        backgroundColor: Colors.grey[850],
      ),
      body: FutureBuilder<List<News>>(
        future: _news,
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return Container();
            default:
              while(snapshot.data.isEmpty){
                return Container(child: Text('Loading..'),);
              }
              return ListView.builder(
                itemCount: 15,
                itemBuilder: (context, i) {
                  return getNewsContainer(i, snapshot.data.elementAt(i));
                },
              );
              break;
          }
        },
      )
    );
  }
}