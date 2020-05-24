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
  Future getUsers() {
    var url =
        "https://imdb-api.com/en/API/SearchMovie/k_I10bb66S/" + a.toString();
    print(http.get(url));
    return http.get(url);
  }
}

class User {
  String id;
  String name;
  String email;
  var college;
  var event;
  var g;
  var phone;

  var price;

  User(String id, String name, String email, var college, var event, var g,
      var price, var phone) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.college = college;
    this.event = event;
    this.g = g;
    this.price = price;
    this.phone = phone;
  }

  User.fromJson(Map json)
      : id = json['TCFRegistrationId'],
        name = json['Name'],
        email = json['Email'],
        college = json['College'],
        event = json['Ticket name'],
        g = json['Gender'],
        price = json['TicketPrice'],
        phone = json['ContactNo'];

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'college': college,
      'event': event,
      'g': g,
      'price': price,
      'phone': phone
    };
  }
}

class app extends StatefulWidget {
  @override
  _appState createState() => _appState();
}

class _appState extends State<app> {
  TextEditingController name = new TextEditingController();
  var users = new List<User>();
  _getUsers() {
    API().getUsers().then((response) {
      var o = response;
      //print(o.body.toString().substring(3));
      o = o.body.toString().substring(3);
      setState(() {
        Iterable list = json.decode(o);
        users = list.map((model) => User.fromJson(model)).toList();
      });
    });
  }

  initState() {
    super.initState();
    _getUsers();
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
            child: TextFormField(
              controller: name,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.panorama_vertical),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'Search Movie',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
