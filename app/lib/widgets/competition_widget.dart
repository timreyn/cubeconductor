import 'package:app/api/logged_in_api.dart';
import 'package:app/models/competition_data.dart';
import 'package:flutter/widgets.dart';

@immutable
class CompetitionWidget extends StatelessWidget {
  CompetitionWidget(this._competitionData, this._loggedInApi, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Text(_competitionData.activeCompetition.id),
    );
  }

  final CompetitionData _competitionData;
  final LoggedInApi _loggedInApi;
}