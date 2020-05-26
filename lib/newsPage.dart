import 'package:flutter/material.dart';
import 'Objects/news.dart';
import 'API/apiManager.dart';
import 'package:flutter_crypto_viewer/Parser/cryptoCompare.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<List<News>> _currentNewsList;

  @override
  void initState(){
    _currentNewsList = getNewsList();
    super.initState();
  }

  Future<List<News>> getNewsList() async {
    List<News> newsList = new List<News>();
    ApiManager.getNewsInfoLatest().then((response) {
      setState(() {
        final parsedNews = getParsedNews(response.body);
        for(News n in parsedNews.data){
          newsList.add(n);
        }
      });
    });
    return newsList;
  }

  /// Attempts to launch a provided URL
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Builds a stack widget containing the latest news
  /// On tap, opens user's browser and visits article URL.
  Stack getNewsContainer(News newsObj) {
    return Stack(
      children: <Widget> [
        InkWell(
          onTap: (){
            _launchURL(newsObj.url);
          },
          child: new Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(newsObj.imageurl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Opacity(
                opacity: 0.65,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.03, left: MediaQuery.of(context).size.width*0.03),
                child: Center(
                  child:  Text(newsObj.title, style: GoogleFonts.pTMono(
                    color: Colors.white,
                    fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
                    _currentNewsList = getNewsList();
                  });
                },
            )
        ),
        title: Text("Latest News",
          style: GoogleFonts.pTMono(
          fontSize: 23,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
      ),
      body: FutureBuilder<List<News>>(
        future: _currentNewsList,
        builder: (context, newsRetrieval){
          switch(newsRetrieval.connectionState){
            case ConnectionState.waiting:
              return Container();
            default:
              while(newsRetrieval.data.isEmpty){
                return Container(
                  child: Text('Loading..'),
                );
              }
              return ListView.builder(
                itemCount: 15,
                itemBuilder: (context, i) {
                  return getNewsContainer(newsRetrieval.data.elementAt(i));
                },
              );
              break;
          }
        },
      )
    );
  }
}