import 'dart:async';
import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Todo> fetchTodo() async {
  final response =
      await http.get('https://jsonkeeper.com/b/0B3I');

  if (response.statusCode == 200) {

    return Todo.fromJson(jsonDecode(response.body));
  } else {

    throw Exception('Failed to load Todo');
  }
}

class Todo {
  int _id;
  String _title;
  String _description;
  bool _done;
  bool _candceled;
  String _date;
  // int _priority;

  Todo(this._title, this._done, this._date,this._candceled, [this._description]);
  Todo.withId(this._id, this._title, this._done,this._candceled, this._date, [this._description]);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  bool get candceled =>_candceled;
  bool get done =>_done;
  String get date => _date;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }



  set date(String newDate) {
    _date = newDate;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["title"] = _title;
    map["description"] = _description;
    map["done"] = _done;
    map["candceled"] = _candceled;
    map["date"] = _date;
    if(_id != null){
      map["id"] = _id;
    }
    return map;
  }

  Todo.fromJson (dynamic json){
    this._id = json["id"];
    this._title = json["title"];
    this._description = json["description"];
    this._done = json["done"];
    this._candceled = json["candceled"];
    this._date = json["date"];
  }

}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Todo> futureTodo;

  @override
  void initState() {
    super.initState();
    futureTodo = fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data '),
        ),
        body: Center(
          child: FutureBuilder<Todo>(
            future: futureTodo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}