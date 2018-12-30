import 'package:app/api/my_competitions.pb.dart';
import 'package:app/app_bar.dart';
import 'package:app/competition_dates.dart';
import 'package:app/state/shared_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

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
      return new Container();
    }

    return new Scaffold(
        appBar: conductorAppBar(context, _sharedState, "Upcoming Competitions"),
        body: new ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          children: competitionRows(),
        ));
  }

  List<Widget> competitionRows() {
    List<Widget> rows = new List();
    rows.addAll(_sharedState.competitionState.myCompetitions.entries
        .map((MyCompetitionsEntry c) {
      Duration timeUntilStart =
          startDate(c.competition).difference(DateTime.now());

      return new Container(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: new Container(
          decoration: new BoxDecoration(
            border: new Border.all(color: const Color(0xff808080)),
            borderRadius: new BorderRadius.circular(16.0),
          ),
          padding: const EdgeInsets.all(20.0),
          child: new Column(
            children: <Widget>[
              new Text(c.competition.name,
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
    return rows;
  }

  SharedState _sharedState;
}
