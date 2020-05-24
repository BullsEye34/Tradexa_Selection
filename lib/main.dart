import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() => {
      runApp(
        MaterialApp(
          home: app(),
        ),
      )
    };

class app extends StatefulWidget {
  @override
  _appState createState() => _appState();
}

class _appState extends State<app> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
