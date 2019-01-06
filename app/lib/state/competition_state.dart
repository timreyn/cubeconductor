import 'dart:async';

import 'package:app/api/my_competitions.pb.dart';
import 'package:app/api/wcif/activity.pb.dart';
import 'package:app/api/wcif/competition.pb.dart';
import 'package:app/api/wcif/person.pb.dart';
import 'package:app/api/wcif/room.pb.dart';
import 'package:app/api/wcif/venue.pb.dart';
import 'package:app/backend_fetcher.dart';
import 'package:app/competition_dates.dart';
import 'package:app/state/shared_state.dart';
import 'package:mutex/mutex.dart';

class CompetitionState {
  CompetitionState(this._sharedState)
      : _backendFetcher = new BackendFetcher(_sharedState),
        _activeCompetitionMutex = new Mutex();

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
        "/api/v0/competitions/" + competition.id + "/proto", activeCompetition);

    _activeCompetitionMutex.acquire();

    try {
      _activityIdToActivity = new Map();
      _activityIdToVenue = new Map();
      _activityIdToRoom = new Map();
      for (Venue venue in activeCompetition.schedule.venues) {
        for (Room room in venue.rooms) {
          for (Activity activity in room.activities) {
            _populateActivity(activity, venue, room);
          }
        }
      }
      _personIdToPerson = new Map();
      for (Person person in activeCompetition.persons) {
        _personIdToPerson[person.wcaUserId] = person;
      }
    } finally {
      _activeCompetitionMutex.release();
    }
  }

  void _populateActivity(Activity activity, Venue venue, Room room) {
    _activityIdToActivity[activity.id] = activity;
    _activityIdToVenue[activity.id] = venue;
    _activityIdToRoom[activity.id] = room;
    for (Activity childActivity in activity.childActivities) {
      _populateActivity(childActivity, venue, room);
    }
  }

  Activity activityIdToActivity(int id) {
    _activeCompetitionMutex.acquire();
    try {
      return _activityIdToActivity[id];
    } finally {
      _activeCompetitionMutex.release();
    }
  }

  Venue activityIdToVenue(int id) {
    _activeCompetitionMutex.acquire();
    try {
      return _activityIdToVenue[id];
    } finally {
      _activeCompetitionMutex.release();
    }
  }

  Room activityIdToRoom(int id) {
    _activeCompetitionMutex.acquire();
    try {
      return _activityIdToRoom[id];
    } finally {
      _activeCompetitionMutex.release();
    }
  }

  Person personIdToPerson(int id) {
    _activeCompetitionMutex.acquire();
    try {
      return _personIdToPerson[id];
    } finally {
      _activeCompetitionMutex.release();
    }
  }

  MyCompetitions myCompetitions;
  Competition ongoingCompetition;
  Competition activeCompetition;

  Map<int, Activity> _activityIdToActivity;
  Map<int, Room> _activityIdToRoom;
  Map<int, Venue> _activityIdToVenue;

  Map<int, Person> _personIdToPerson;

  Mutex _activeCompetitionMutex;

  final SharedState _sharedState;
  final BackendFetcher _backendFetcher;
}
