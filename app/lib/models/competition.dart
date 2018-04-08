import 'activity.dart';
import 'assignment.dart';
import 'event.dart';
import 'person.dart';
import 'room.dart';
import 'schedule.dart';
import 'venue.dart';

class Competition {
  factory Competition(Map competitionData) {
    Map<int, Person> persons;
    for (Map personData in competitionData['persons']) {
      Person person = new Person(personData);
      persons[person.wcaUserId] = person;
    }

    Map<String, Event> events;
    for (Map eventData in competitionData['events']) {
      Event event = new Event(eventData);
      events[event.id] = event;
    }

    Schedule schedule = new Schedule(competitionData['schedule']);

    // Set up cross-references:
    // Link Assignments to Activities.
    Map<String, Activity> activities;
    for (Venue venue in schedule.venues) {
      for (Room room in venue.rooms) {
        for (Activity activity in room.allActivities()) {
          activities[activity.id] = activity;
        }
      }
    }
    for (Person person in persons.values) {
      for (Assignment assignment in person.assignments) {
        Activity activity = activities[assignment.activityId];
        if (activity == null) {
          continue;
        }
        activity.addAssignment(assignment);
        assignment.setActivity(activity);
      }
    }

    return Competition._internal(
      id: competitionData['id'],
      name: competitionData['name'],
      shortName: competitionData['shortName'],
      persons: persons,
      events: events,
      schedule: schedule,
    );
  }

  Competition._internal({
    this.id, this.name, this.shortName, this.persons, this.events,
    this.schedule});

  final String id;
  final String name;
  final String shortName;
  final Map<int, Person> persons;
  final Map<String, Event> events;
  final Schedule schedule;
}