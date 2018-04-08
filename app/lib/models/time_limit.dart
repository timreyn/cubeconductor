import "attempt_result.dart";
import "event.dart";

class TimeLimit {
  factory TimeLimit(Map timeLimitData, Event event) {
    if (timeLimitData == null) {
      return null;
    }

    return TimeLimit._internal(attemptResult: AttemptResult(
        result: timeLimitData["centiseconds"], event: event));
  }

  TimeLimit._internal({this.attemptResult});

  final AttemptResult attemptResult;
}