import 'activity.dart';

class Room {
  factory Room(Map roomData) {
    Room room = Room._internal(id: roomData["id"], name: roomData["name"]);

    for (Map activityData in roomData["activities"]) {
      room.activities.add(new Activity(activityData, room));
    }
    return room;
  }

  Room._internal({this.id, this.name, this.activities});

  Iterable<Activity> allActivities() sync* {
    for (Activity activity in activities) {
      yield activity;
      for (Activity childActivity in activity.allChildActivities()) {
        yield childActivity;
      }
    }
  }

  final String id;
  final String name;
  final List<Activity> activities;
}