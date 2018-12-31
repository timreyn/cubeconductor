import 'dart:async';

import 'package:app/api/my_competitions.pb.dart';
import 'package:app/api/wcif/competition.pb.dart';
import 'package:app/backend_fetcher.dart';
import 'package:app/competition_dates.dart';
import 'package:app/state/shared_state.dart';

class CompetitionState {
  CompetitionState(this._sharedState)
      : _backendFetcher = new BackendFetcher(_sharedState);

  void updateState() async {
    if (myCompetitions == null) {
      await updateMyCompetitionsData();
    }

    if (ongoingCompetition != null) {
      await updateActiveCompetition(ongoingCompetition);
    } else {
      await updateMyCompetitionsData();
    }
  }

  Future<void> updateMyCompetitionsData() async {
    myCompetitions = await _backendFetcher.get("/api/v0/my_competitions", new MyCompetitions());

    DateTime now = DateTime.now().toLocal();
    ongoingCompetition = null;

    for (MyCompetitionsEntry entry in myCompetitions.entries) {
      if (now.isAfter(startDate(entry.competition)) &&
          now.isBefore(endDate(entry.competition).add(new Duration(days: 1)))) {
        ongoingCompetition = entry.competition;
      }
    }
  }

  Future<void> updateActiveCompetition(Competition competition) async {
    _backendFetcher.get(
        "/api/v0/competitions/" + competition.id + "/wcif", activeCompetition);
  }

  MyCompetitions myCompetitions;
  Competition ongoingCompetition;
  Competition activeCompetition;

  final SharedState _sharedState;
  final BackendFetcher _backendFetcher;
}
