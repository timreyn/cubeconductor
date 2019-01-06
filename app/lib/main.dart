import 'package:app/widgets/home_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      title: 'Cube Conductor',
      home: HomeWidget(),
      theme: new ThemeData(
        primaryColor: Colors.blue,
      )));
}
