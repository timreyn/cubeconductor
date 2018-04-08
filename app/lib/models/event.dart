import 'round.dart';

class Event {
  factory Event(Map eventData) {
    Map<int, Round> rounds;

    Event event = Event._internal(id: eventData["id"], rounds: rounds);

    for (Map roundData in eventData["rounds"]) {
      Round round = new Round(roundData, event);
      event.rounds[round.number] = round;
    }

    return event;
  }

  Event._internal({this.id, this.rounds});

  final String id;
  final Map<int, Round> rounds;
}