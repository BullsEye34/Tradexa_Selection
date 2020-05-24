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
        "https://imdb-api.com/en/API/SearchMovie/k_g3MCq1Ep/" + a.toString();
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

  Map<String, dynamic> list;
  var users = new List<Movie>();
  _getUsers(var a) async {
    API().getUsers(a).then((response) async {
      var o = response;
      o = o.body;
      list = await json.decode(o);
      List<dynamic> data = list["results"];
      /* for (var i = 0; i < data.length; i++) {
        print(data[i]["title"]);
      } */
      setState(() {
        list = json.decode(o);
        data = list["results"];
        // print(data.length);
        // users = list.map((model) => Movie.fromJson(model)).toList();
      });
    });
    //print(data.length);
    // print(list['results'][3]['title']);
  }

  initState() {
    super.initState();
    _getUsers("resident evil");
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
                Form(
                  onChanged: () => {
                    (name.text.toString() == "")
                        ? print("nothing")
                        : _getUsers(name.text),
                  },
                  child: TextFormField(
                    onFieldSubmitted: (value) => {
                      (value.isEmpty)
                          ? print(
                              "Empty***************************************")
                          : _getUsers(name.text),
                      //print("Something")
                    },
                    textInputAction: TextInputAction.go,
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
                ),
                Expanded(
                  child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: list["results"].length,
                    itemBuilder: (context, index) {
                      return (list.isEmpty)
                          ? CupertinoActivityIndicator()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    height: 140,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(.1),
                                            offset: Offset(0, 0),
                                            blurRadius: 10,
                                            spreadRadius: 3)
                                      ],
                                    ),
                                    child:
                                        /* Text(
                                      list["results"][index]["title"].toString(),
                                    ), */
                                        Row(
                                      children: [
                                        SizedBox(
                                          width: 150,
                                        ),
                                        Flexible(
                                          child: Text(
                                            list["results"][index]["title"]
                                                .toString(),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          image(index),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  image(index) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: CupertinoActivityIndicator(),
        ),
        Container(
          height: 150,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  offset: Offset(0, 0),
                  blurRadius: 10,
                  spreadRadius: 3)
            ],
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            list["results"][index]["image"].toString(),
            height: 150,
          ),
        ),
      ],
    );
  }
}
