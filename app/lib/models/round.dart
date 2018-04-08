import 'activity_code.dart';
import 'advancement_condition.dart';
import 'cutoff.dart';
import 'event.dart';
import 'format.dart';
import 'time_limit.dart';

class Round {
  factory Round(Map roundData, Event event) {
    int roundNumber = ActivityCode(roundData["id"]).roundNumber;

    return Round._internal(number: roundNumber,
        event: event,
        format: Format(roundData["format"]),
        timeLimit: TimeLimit(roundData["timeLimit"], event),
        cutoff: Cutoff(roundData["cutoff"], event),
        advancementCondition: AdvancementCondition(
            roundData["advancementCondition"], event));
  }

  Round._internal({
    this.number, this.event, this.format, this.timeLimit, this.cutoff,
    this.advancementCondition});

  final int number;
  final Event event;
  final Format format;
  final TimeLimit timeLimit;
  final Cutoff cutoff;
  final AdvancementCondition advancementCondition;
}