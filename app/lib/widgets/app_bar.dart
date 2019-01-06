import 'package:flutter/material.dart';

class MenuItem {
  MenuItem({this.text, this.onClick});

  String text;
  Function onClick;
}

Widget buildAppBar(BuildContext context, List<MenuItem> items, String title) {
  var actions = <Widget>[];
  if (items.isNotEmpty) {
    actions = <Widget>[
      new PopupMenuButton<MenuItem>(onSelected: (MenuItem option) {
        option.onClick();
      }, itemBuilder: (BuildContext context) {
        return items.map((MenuItem option) {
          return new PopupMenuItem<MenuItem>(
            value: option,
            child: new Text(option.text),
          );
        }).toList();
      })
    ];
  }
  return new AppBar(
    title: new Text(title),
    actions: actions,
  );
}
