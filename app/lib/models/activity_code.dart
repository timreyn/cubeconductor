class ActivityCode {
  factory ActivityCode(String code) {
    List<String> codeParts = code.split("-");

    String eventId = codeParts.removeAt(0);
    if (eventId == "other") {
      return ActivityCode._internal(otherActivity: codeParts.join("-"));
    }

    int roundNumber;
    String groupName;
    int attemptNumber;

    for (String codePart in codeParts) {
      String prefix = codePart[0];
      String remainder = codePart.replaceFirst(prefix, "");
      if (prefix == "r") {
        roundNumber = int.parse(remainder);
      } else if (prefix == "g") {
        groupName = remainder;
      } else if (prefix == "a") {
        attemptNumber = int.parse(remainder);
      }
    }

    return ActivityCode._internal(eventId: eventId,
        roundNumber: roundNumber,
        groupName: groupName,
        attemptNumber: attemptNumber);
  }

  ActivityCode._internal({
    this.eventId, this.roundNumber, this.groupName, this.attemptNumber,
    this.otherActivity});

  final String eventId;
  final int roundNumber;
  final String groupName;
  final int attemptNumber;
  final String otherActivity;
}