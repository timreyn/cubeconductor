import 'package:app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget loadingWidget(BuildContext context) {
  return new Scaffold(
    appBar: buildAppBar(context, new List<MenuItem>(), "Cube Conductor"),
    body: new Center(
      child: new Text(
        'Loading...',
      ),
    ),
  );
}