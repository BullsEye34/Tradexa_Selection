import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => {
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: app(),
        ),
      )
    };

class API {
  var a;
  API({var a}) {
    this.a = a;
  }
  Future getUsers(a) {
    var url =
        "https://imdb-api.com/en/API/SearchMovie/k_I10bb66S/" + a.toString();
    return http.get(url);
  }
}

class Movie {
  String searchType;
  String expression;
  List<Results> results;
  String errorMessage;

  Movie({this.searchType, this.expression, this.results, this.errorMessage});

  Movie.fromJson(Map<String, dynamic> json) {
    searchType = json['searchType'];
    expression = json['expression'];
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchType'] = this.searchType;
    data['expression'] = this.expression;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    data['errorMessage'] = this.errorMessage;
    return data;
  }
}

class Results {
  String id;
  String resultType;
  String image;
  String title;
  String description;

  Results({this.id, this.resultType, this.image, this.title, this.description});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resultType = json['resultType'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['resultType'] = this.resultType;
    data['image'] = this.image;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}

class app extends StatefulWidget {
  @override
  _appState createState() => _appState();
}

class _appState extends State<app> {
  TextEditingController name = new TextEditingController();
  List<dynamic> data;
  var users = new List<Movie>();
  _getUsers(var a) {
    API().getUsers(a).then((response) {
      var o = response;
      o = o.body;
      Map<String, dynamic> list = json.decode(o);
      List<dynamic> data = list["results"];
      for (var i = 0; i < 6; i++) {
        print(data[i]["title"]);
      }
      setState(() {
        list = json.decode(o);
        data = list["results"];
        print(data.length);
        // users = list.map((model) => Movie.fromJson(model)).toList();
      });
    });
    print(data.length);
  }

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.panorama_vertical),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                      ),
                      onPressed: () {
                        _getUsers(name.text);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Search Movie',
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Text(data[index]["title"]);
                  },
                  itemCount: data.length,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
