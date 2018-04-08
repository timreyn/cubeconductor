import 'activity.dart';
import 'person.dart';

class Assignment {
  Assignment(Map assignmentData)
      :
        activityId = assignmentData['activityId'],
        stationNumber = assignmentData['stationNumber'],
        assignmentCode = assignmentData['assignmentCode'];

  void setPerson(Person person) {
    if (_person == null) {
      _person = person;
    } else {
      throw Exception("Attempting to set Person multiple times.");
    }
  }

  void setActivity(Activity activity) {
    if (_activity == null) {
      _activity = activity;
    } else {
      throw Exception("Attempting to set Activity multiple times.");
    }
  }

  final String activityId;
  final int stationNumber;
  final String assignmentCode;

  Activity _activity;
  Person _person;
}