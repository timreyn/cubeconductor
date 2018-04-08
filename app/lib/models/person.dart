import 'assignment.dart';

class Person {
  factory Person(Map personData) {
    String avatarThumbUrl;
    Map avatarData = personData['avatar'];
    if (avatarData != null) {
      avatarThumbUrl = avatarData['thumbUrl'];
    }

    List<Assignment> assignments = personData['assignments'].map(
        (Map assignmentData) => new Assignment(assignmentData)
    );

    Person person = Person._internal(name: personData['name'],
        wcaUserId: personData['wcaUserId'],
        wcaId: personData['wcaId'],
        avatarThumbUrl: avatarThumbUrl,
        assignments: assignments);

    for (Assignment assignment in assignments) {
      assignment.setPerson(person);
    }

    return person;
  }

  Person._internal({
    this.name, this.wcaUserId, this.wcaId, this.avatarThumbUrl,
    this.assignments, this.roles});

  final String name;
  final int wcaUserId;
  final String wcaId;
  final String avatarThumbUrl;
  final List<Assignment> assignments;
  final List<String> roles;
}