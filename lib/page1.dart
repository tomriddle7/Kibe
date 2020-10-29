import 'package:flutter/material.dart';
import 'detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlId {
  String name;
  String arg;

  PlId(this.name, this.arg);
}

class Page1 extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<Page1> {

  List<dynamic> _response = [];

  _httpGet() async {
    var response = await http.get('https://apis.naver.com/vibeWeb/musicapiweb/vibe/v3/today/billboardSecondary.json');
    String responseBody = response.body;
    // print('res >> $responseBody');

    Map<String, dynamic> json = jsonDecode('$responseBody');

    List<dynamic> playList = json['response']['result']['billboards'];

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
          '오늘의 추천음악',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: new ListView.builder(
        itemBuilder: (context, index) {
          return new Card(
            child: ListTile(
              leading: Image.network(
                  _response[index]['content']['playlist']['image']['baseImageUrl'].toString(),
              ),
              title: Text(_response[index]['content']['playlist']['title'].toString()),
              subtitle: Text(
                _response[index]['content']['playlist']['desc'].toString(),
              ),
              onTap: () {
                final plId = PlId(_response[index]['content']['playlist']['title'].toString(), _response[index]['content']['playlist']['plId'].toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Detail(plId: plId)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}