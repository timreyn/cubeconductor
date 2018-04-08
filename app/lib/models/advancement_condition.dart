import 'attempt_result.dart';
import 'event.dart';

class AdvancementCondition {
  factory AdvancementCondition(Map advancementConditionData, Event event) {
    if (advancementConditionData == null) {
      return null;
    }
    int level = advancementConditionData["level"];
    switch (advancementConditionData["type"]) {
      case "ranking":
        return AdvancementCondition._internal(ranking: level);
      case "percent":
        return AdvancementCondition._internal(percent: level);
      case "attemptResult":
        return AdvancementCondition._internal(attemptResult: AttemptResult(
          result: level, event: event,
        ));
      default:
        return null;
    }
  }

  AdvancementCondition._internal(
      {this.ranking, this.percent, this.attemptResult});

  final int ranking;
  final int percent;
  final AttemptResult attemptResult;
}