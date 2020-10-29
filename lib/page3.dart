import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page3 extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<Page3> {
  final _stationController = TextEditingController();

  List<Card> _buildCards() {
    print('>>> _data.length? ${_response.length}');

    if (_response.length == 0) {
      return <Card>[];
    }

    List<Card> res = [];
    for (var i = 0; i < _response.length; i++) {
      Card card = Card(
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.network(
                _response[i]['album']['imageUrl'].toString(),
                fit: BoxFit.fitHeight,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _response[i]['trackTitle'].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      _response[i]['artists'][0]['artistName'].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
      res.add(card);
    }

    return res;
  }

  List<dynamic> _response = [];

  _httpGet() async {
    // api 주소 생성
    StringBuffer apiUrl = StringBuffer();
    apiUrl.write('https://apis.naver.com/vibeWeb/musicapiweb/v3/search/track.json?query=');
    apiUrl.write(_stationController.text);
    apiUrl.write('&start=1&display=100&sort=RELEVANCE');

    var response = await http.get(apiUrl.toString());
    String responseBody = response.body;
    print('res >> $responseBody');

    Map<String, dynamic> json = jsonDecode('$responseBody');

    List<dynamic> playList = json['response']['result']['tracks'];

    setState(() {
      _response = playList;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  _onClick() {
    _httpGet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
          '검색',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            child: Row(
              children: <Widget>[
                Text('검색어'),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 150,
                  child: TextField(
                    controller: _stationController,
                  ),
                ),
                Expanded(
                  child: SizedBox.shrink(),
                ),
                RaisedButton(
                  child: Text('조회'),
                  onPressed: _onClick,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Flexible(
            child: GridView.count(
              crossAxisCount: 2,
                children: _buildCards(),
            )
          )


          // new ListView.builder(
          //   itemBuilder: (context, index) {
          //     return new Card(
          //       child: ListTile(
          //         leading: Image.network(
          //           _response[index]['imageUrl'].toString(),
          //         ),
          //         title: Text(_response[index]['title'].toString()),
          //         subtitle: Text(
          //           _response[index]['leftButton']['text'].toString(),
          //         ),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}