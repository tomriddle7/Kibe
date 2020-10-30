import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page2 extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<Page2> {

  List<dynamic> _response = [];

  _httpGet() async {
    var response = await http.get('https://apis.naver.com/vibeWeb/musicapiweb/vibe/v1/search/newsCards.json');
    String responseBody = response.body;
    // print('res >> $responseBody');

    Map<String, dynamic> json = jsonDecode('$responseBody');

    List<dynamic> playList = json['response']['result']['newsCards'];

    setState(() {
      _response = playList;
    });
  }

  @override
  void initState() {
    super.initState();
    _httpGet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
          'NEWS',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: new ListView.builder(
        itemCount: _response.length,
        itemBuilder: (context, index) {
          return new Card(
            child: ListTile(
              leading: Image.network(
                  _response[index]['imageUrl'].toString(),
              ),
              title: Text(_response[index]['title'].toString()),
              subtitle: Text(
                _response[index]['leftButton']['text'].toString(),
              ),
              onTap: () async {

                var url = _response[index]['leftButton']['action'].toString();
                await launch(url, forceWebView: true, forceSafariVC: true);
              },
            ),
          );
        },
      ),
    );
  }
}