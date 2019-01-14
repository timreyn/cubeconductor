import 'package:app/proto/my_competitions.pb.dart';
import 'package:app/proto/user.pb.dart';

mixin LoggedInApi {
  // Returns the logged-in user.
  User user();

  // Returns this user's competition list.
  MyCompetitions myCompetitions();

  // Sets the provided competition ID as the active competition.
  void setActiveCompetition(String competitionId);
}