import 'dart:async';

import 'package:app/proto/wcif/activity.pb.dart';
import 'package:app/proto/wcif/competition.pb.dart';
import 'package:app/proto/wcif/person.pb.dart';
import 'package:app/proto/wcif/room.pb.dart';
import 'package:app/proto/wcif/venue.pb.dart';
import 'package:app/util/backend_fetcher.dart';

class CompetitionData {
  CompetitionData(this._backendFetcher);

  Future<void> loadCompetition(String competitionId) async {
    activeCompetition = new Competition();
    await _backendFetcher.get(
        "/api/v0/competition/" + competitionId + "/proto", activeCompetition);

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
    return _activityIdToActivity[id];
  }

  Venue activityIdToVenue(int id) {
    return _activityIdToVenue[id];
  }

  Room activityIdToRoom(int id) {
    return _activityIdToRoom[id];
  }

  Person personIdToPerson(int id) {
    return _personIdToPerson[id];
  }

  Competition activeCompetition;

  Map<int, Activity> _activityIdToActivity;
  Map<int, Room> _activityIdToRoom;
  Map<int, Venue> _activityIdToVenue;

  Map<int, Person> _personIdToPerson;

  final BackendFetcher _backendFetcher;
}
