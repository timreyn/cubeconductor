import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_bar.dart';
import 'login_flow.dart';

void main() => runApp(new CubeConductorApp());

class CubeConductorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Cube Conductor',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (_) => new HomeWidget(),
        "/login": (_) => new LoginFlowWidget(),
      },
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<HomeWidget> {
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {this.sharedPreferences = prefs;});
    });
  }

  SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: conductorAppBar(context, sharedPreferences),
      body: new Center(
        child: new Text(
          'Welcome to Cube Conductor!!!',
        ),
      ),
    );
  }
}
