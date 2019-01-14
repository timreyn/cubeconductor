import 'package:app/api/logged_in_api.dart';
import 'package:app/proto/my_competitions.pb.dart';
import 'package:app/util/competition_dates.dart';
import 'package:flutter/widgets.dart';

@immutable
class MyCompetitionsWidget extends StatelessWidget {
  MyCompetitionsWidget(this._loggedInApi, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      children: _loggedInApi.myCompetitions().entries
          .map((MyCompetitionsEntry entry) =>
              new _CompetitionChipWidget(entry, _loggedInApi))
          .toList(),
    );
  }

  final LoggedInApi _loggedInApi;
}

@immutable
class _CompetitionChipWidget extends StatelessWidget {
  _CompetitionChipWidget(this._competition, this._loggedInApi, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration timeUntilStart =
        startDate(_competition.competition).difference(DateTime.now());

    return new Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: new GestureDetector(
        onTap: () {
          _loggedInApi.setActiveCompetition(_competition.competition.id);
        },
        child: new Container(
          decoration: new BoxDecoration(
            border: new Border.all(color: const Color(0xff808080)),
            borderRadius: new BorderRadius.circular(16.0),
          ),
          padding: const EdgeInsets.all(20.0),
          child: new Column(
            children: <Widget>[
              new Text(_competition.competition.name,
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
      ),
    );
  }

  final MyCompetitionsEntry _competition;
  final LoggedInApi _loggedInApi;
}
