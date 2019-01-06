import 'package:flutter/material.dart';

class MenuItem {
  MenuItem({this.text, this.onClick});

  String text;
  Function onClick;
}

Widget buildAppBar(
    BuildContext context, List<MenuItem> items, String title) {
  return new AppBar(
    title: new Text(title),
    actions: <Widget>[
      new PopupMenuButton<MenuItem>(onSelected: (MenuItem option) {
        option.onClick(context);
      }, itemBuilder: (BuildContext context) {
        return items.map((MenuItem option) {
          return new PopupMenuItem<MenuItem>(
            value: option,
            child: new Text(option.text),
          );
        }).toList();
      }),
    ],
  );
}
