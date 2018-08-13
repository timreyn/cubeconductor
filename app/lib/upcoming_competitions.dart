import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'app_bar.dart';
import 'competition_state.dart';
import 'shared_state.dart';

class UpcomingCompetitionsWidget extends StatefulWidget {
  UpcomingCompetitionsWidget(this._sharedState, {Key key}) : super(key: key);

  @override
  _UpcomingCompetitionsState createState() =>
      new _UpcomingCompetitionsState(_sharedState);

  SharedState _sharedState;
}

class _UpcomingCompetitionsState extends State<UpcomingCompetitionsWidget> {
  _UpcomingCompetitionsState(this._sharedState);

  @override
  Widget build(BuildContext context) {
    if (!_sharedState.loginState.isLoggedIn()) {
      Navigator.pushReplacementNamed(context, "/login");
      // TODO: return a widget containing a spinner.
      return new Container();
    }
    if (_sharedState.competitionState.myCompetitions == null) {
      _sharedState.competitionState.updateMyCompetitionsData().then((_) {
        setState(() {});
      });
      // TODO: return a widget containing a spinner.
      return new Container();
    }

    return new Scaffold(
        appBar: conductorAppBar(context, _sharedState),
        body: new ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: competitionRows(),
        ));
  }

  List<Widget> competitionRows() {
    List<Widget> rows = new List();
    for (int i = 0; i < 5; i++) {
      rows.addAll(_sharedState.competitionState.myCompetitions
          .map((SlimCompetition c) {
        Duration timeUntilStart = c.startDate.difference(DateTime.now());

        return new Container(
          padding: const EdgeInsets.all(5.0),
          child: new Container(
            decoration: new BoxDecoration(
              border: new Border.all(color: const Color(0xff808080)),
              borderRadius: new BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(20.0),
            child: new Column(
              children: <Widget>[
                new Text(
                      c.name,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                      )),

                new Text(
                    "Starts in " + (timeUntilStart.inDays + 1).toString() + " days",
                    style: new TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 10.0,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList());
    }
    return rows;
  }

  SharedState _sharedState;
}
