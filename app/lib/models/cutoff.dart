import 'attempt_result.dart';
import 'event.dart';

class Cutoff {
  factory Cutoff(Map cutoffData, Event event) {
    if (cutoffData == null) {
      return null;
    }
    return Cutoff._internal(numberOfAttempts: cutoffData["numberOfAttempts"],
        attemptResult: AttemptResult(
            result: cutoffData["attemptResult"], event: event));
  }

  Cutoff._internal({this.numberOfAttempts, this.attemptResult, this.event});

  final int numberOfAttempts;
  final AttemptResult attemptResult;
  final Event event;
}