import 'package:flutter/material.dart';
import 'news.dart';
import 'api_manager.dart';
import 'package:flutter_crypto_viewer/crypto_compare_parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<List<News>> _news;


  /*
    Initialize state
    Start retrieving news list
   */
  @override
  void initState(){
    _news = getList();
    super.initState();
  }


  /*
    Returns a Future object that will become a List of News objects
    Currently retrieves the latest news
   */
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



  //Attempts to launch a provided URL
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /*
    Creates a Stack widget that will use a News object
    Fills in data corresponding to the object's data
   */
  Stack getNewsContainer(News snap) {
    return Stack(
      children: <Widget> [
        InkWell(
          onTap: (){
            _launchURL(snap.url);
          },
          child: new Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(snap.imageurl),
                fit: BoxFit.cover,
              ),
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
            child:  Text(snap.title, style: GoogleFonts.pTMono(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }


  /*
    Builds a Widget that contains the News list and App Bar
    Uses a FutureBuilder to try and retrieve the _news list variable
   */
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
        title: Text("Latest News",
          style: GoogleFonts.pTMono(
          fontSize: 23,
          ),
        ),
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
                  return getNewsContainer(snapshot.data.elementAt(i));
                },
              );
              break;
          }
        },
      )
    );
  }
}