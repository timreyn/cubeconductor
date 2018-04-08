import 'activity_code.dart';
import 'assignment.dart';
import 'room.dart';

class Activity {
  factory Activity(Map activityData, Room room) {
    List<Activity> childActivities = activityData["childActivities"].map(
        (Map childActivityData) => new Activity(childActivityData, room)
    );

    return Activity._internal(
      id: activityData["id"],
      name: activityData["name"],
      activityCode: ActivityCode(activityData["activityCode"]),
      startTime: DateTime.parse(activityData["startTime"]),
      endTime: DateTime.parse(activityData["endTime"]),
      childActivities: childActivities,
      room: room,
    );
  }

  Activity._internal({
    this.id, this.name, this.activityCode, this.startTime, this.endTime,
    this.childActivities, this.room});

  Iterable<Activity> allChildActivities() sync* {
    for (Activity activity in childActivities) {
      yield activity;
      for (Activity childActivity in activity.allChildActivities()) {
        yield childActivity;
      }
    }
  }

  void addAssignment(Assignment assignment) {
    this._assignments.add(assignment);
  }

  final String id;
  final String name;
  final ActivityCode activityCode;
  final DateTime startTime;
  final DateTime endTime;
  final List<Activity> childActivities;
  final Room room;

  List<Assignment> _assignments;
}