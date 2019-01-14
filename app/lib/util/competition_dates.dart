import 'package:app/proto/wcif/competition.pb.dart';

DateTime startDate(Competition competition) {
  return DateTime.parse(competition.schedule.startDate);
}

DateTime endDate(Competition competition) {
  return startDate(competition)
      .add(new Duration(days: competition.schedule.numberOfDays - 1));
}
