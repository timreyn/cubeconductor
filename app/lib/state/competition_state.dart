import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import '../backend_fetcher.dart';
import 'shared_state.dart';
import '../models/competition.dart';

class CompetitionState {
  CompetitionState(this._sharedState) :
      _backendFetcher = new BackendFetcher(_sharedState);

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
    myCompetitions = List();
    String response = await _backendFetcher.get("/api/v0/my_competitions");
    List responseJson = json.decode(response);

    for (Map competitionJson in responseJson) {
      myCompetitions.add(SlimCompetition(competitionJson));
    }

    DateTime now = DateTime.now().toLocal();
    ongoingCompetition = null;

    for (SlimCompetition competition in myCompetitions) {
      if (now.isAfter(competition.startDate) &&
          now.isBefore(competition.endDate.add(new Duration(days: 1)))) {
        ongoingCompetition = competition;
      }
    }
  }

  Future<void> updateActiveCompetition(SlimCompetition competition) async {
    String response = await _backendFetcher.get(
        "/api/v0/competitions/" + competition.id + "/wcif");
    Map competitionJson = json.decode(response);
    Competition newCompetition = new Competition(competitionJson);
    activeCompetition = newCompetition;
  }

  List<SlimCompetition> myCompetitions;
  SlimCompetition ongoingCompetition;
  Competition activeCompetition;

  final SharedState _sharedState;
  final BackendFetcher _backendFetcher;
}

class SlimCompetition {
  SlimCompetition(Map competitionData) :
      id = competitionData["competition"]["id"],
      name = competitionData["competition"]["name"],
      startDate = DateTime.parse(competitionData["competition"]["startDate"]),
      endDate = DateTime.parse(competitionData["competition"]["endDate"]),
      isAdmin = competitionData["isAdmin"];

  String formatDates() {
    DateFormat format = new DateFormat.yMMMMd();
    if (startDate.isAtSameMomentAs(endDate)) {
      return format.format(startDate);
    } else {
      return format.format(startDate) + " - " + format.format(endDate);
    }
  }

  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAdmin;
}