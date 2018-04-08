import 'venue.dart';

class Schedule {
  static int previousScheduleHash;
  static Schedule previousSchedule;

  factory Schedule(Map scheduleData) {
    int scheduleHash = scheduleData.hashCode;
    if (scheduleHash == previousScheduleHash) {
      return previousSchedule;
    }
    DateTime startDate = DateTime.parse(scheduleData["startDate"]);
    DateTime endDate = startDate.add(
        new Duration(days: scheduleData["numberOfDays"]));

    List<Venue> venues;
    for (Map venueData in scheduleData["venues"]) {
      venues.add(new Venue(venueData));
    }

    previousScheduleHash = scheduleHash;
    Schedule schedule = Schedule._internal(
        startDate: startDate, endDate: endDate, venues: venues);
    previousSchedule = schedule;
    return schedule;
  }

  Schedule._internal({this.startDate, this.endDate, this.venues});

  final DateTime startDate;
  final DateTime endDate;

  final List<Venue> venues;
}