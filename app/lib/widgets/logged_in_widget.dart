import 'package:app/api/logged_in_api.dart';
import 'package:app/api/shared_api.dart';
import 'package:app/models/competition_data.dart';
import 'package:app/proto/my_competitions.pb.dart';
import 'package:app/proto/user.pb.dart';
import 'package:app/widgets/competition_widget.dart';
import 'package:app/widgets/loading_widget.dart';
import 'package:app/widgets/my_competitions_widget.dart';
import 'package:flutter/material.dart';

@immutable
class LoggedInWidget extends StatefulWidget {
  LoggedInWidget(this._sharedApi, this._user, {Key key}) : super(key: key);

  final SharedApi _sharedApi;
  final User _user;

  @override
  _LoggedInState createState() => new _LoggedInState(_sharedApi, _user);
}

enum _ActiveFlow {
  MY_COMPETITIONS,
  COMPETITION,
}

class _LoggedInState extends State<LoggedInWidget> implements LoggedInApi {
  _LoggedInState(this._sharedApi, this._user);

  _ActiveFlow _activeFlow = _ActiveFlow.MY_COMPETITIONS;

  CompetitionData _activeCompetition;
  MyCompetitions _myCompetitions;

  final SharedApi _sharedApi;
  final User _user;

  @override
  Widget build(BuildContext context) {
    if (_myCompetitions == null) {
      _sharedApi.backendFetcher().get("/api/v0/my_competitions", new MyCompetitions())
          .then((MyCompetitions myCompetitions) {
        setState(() {
          _myCompetitions = myCompetitions;
        });
      });
      return loadingWidget(context);
    }

    switch (_activeFlow) {
      case _ActiveFlow.MY_COMPETITIONS:
        _sharedApi.onBack(null);
        return new MyCompetitionsWidget(this);
      case _ActiveFlow.COMPETITION:
        _sharedApi.onBack(() {
          setState(() {
            _activeFlow = _ActiveFlow.MY_COMPETITIONS;
            _activeCompetition = null;
          });
        });
        return new CompetitionWidget(_activeCompetition, this);
    }
    return null;
  }

  @override
  User user() {
    return _user;
  }

  @override
  MyCompetitions myCompetitions() {
    return _myCompetitions;
  }

  @override
  void setActiveCompetition(String competitionId) {
    _activeCompetition = new CompetitionData(_sharedApi.backendFetcher());
    _activeCompetition.loadCompetition(competitionId).then((_) {
      setState(() {
        _activeFlow = _ActiveFlow.COMPETITION;
      });
    });
  }
}