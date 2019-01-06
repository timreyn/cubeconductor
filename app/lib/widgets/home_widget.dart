import 'package:app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  _MainState createState() => new _MainState();
}

class _MainState extends State<HomeWidget> {
  _MainState();

  @override
  Widget build(BuildContext context) {
    List<MenuItem> menuItems = _defaultMenuItems();

    return new Scaffold(
      appBar: buildAppBar(context, menuItems, "Cube Conductor"),
      body: new Center(
        child: new Text(
          'Welcome to Cube Conductor!!!',
        ),
      ),
    );
  }

  List<MenuItem> _defaultMenuItems() {
    return new List<MenuItem>();
  }
}
