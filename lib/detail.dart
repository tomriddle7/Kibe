import 'package:flutter/material.dart';
import 'package:tibe/page1.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Detail extends StatefulWidget {
  final PlId plId;

  Detail({@required this.plId});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<Detail> {

  List<dynamic> _response = [];

  _httpGet() async {
    // api 주소 생성
    StringBuffer apiUrl = StringBuffer();
    apiUrl.write('https://apis.naver.com/vibeWeb/musicapiweb/vibe/v1/playlist/');
    apiUrl.write(widget.plId.arg);
    apiUrl.write('/artists.json');

    var response = await http.get(apiUrl.toString());
    String responseBody = response.body;
    // print('res >> $responseBody');

    Map<String, dynamic> json = jsonDecode('$responseBody');

    List<dynamic> playList = json['response']['result']['artists'];

    setState(() {
      _response = playList;
    });
  }

  @override
  void initState() {
    super.initState();
    _httpGet();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: Colors.white,
  //         title: Text(
  //           'Second',
  //           style: TextStyle(color: Colors.black),
  //         ),
  //         centerTitle: true,
  //       ),
  //       body: RaisedButton(
  //         child: Text(widget.plId.arg),
  //         onPressed: () {},
  //       )
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
          widget.plId.name,
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
              title: Text(_response[index]['artistName'].toString()),
              subtitle: Text(
                _response[index]['genreNames'].toString(),
              ),
            ),
          );
        },
      ),
    );
  }
}