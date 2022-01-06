import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Detail.dart';
import './adddata.dart';
import 'editdata.dart';

void main() {
  runApp(new MaterialApp(
    title: "Trashmob",
    home: new Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  Future<List> getData() async {
    final response =
        await http.get(Uri.parse("http://10.0.2.2/komposter/getdata.php"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.orange,
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Produk Katalog"),
        backgroundColor: Colors.green,
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () => Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => new AddData(),
            )),
      ),
      body: new FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                snapshot.error.toString(),
              ));
            } else if (snapshot.hasData) {
              List<dynamic> data = snapshot.data as List<dynamic>;
              return ItemList(list: data);
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({required this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(10.0),
          child: new GestureDetector(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Detail(
                        list: list,
                        index: i,
                      ))),
              child: new Card(
                child: new ListTile(
                  title: new Text(list[i]['item_name']),
                  leading: new Icon(Icons.widgets),
                  subtitle: new Text("Quality : ${list[i]['quality']}"),
                ),
              )),
        );
      },
    );
  }
}
