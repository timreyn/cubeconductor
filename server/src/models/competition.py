import base64
import datetime
import json

from google.appengine.ext import ndb
from google.protobuf import json_format

from src.api.wcif import competition_pb2
from src.api.wcif import schedule_pb2


class Competition(ndb.Model):
  base64 = ndb.TextProperty()

  enabled = ndb.BooleanProperty()

  @staticmethod
  def FromCompetitionSearch(competition_dict):
    competition_proto = competition_pb2.Competition(
        id=competition_dict['id'])

    start_date = datetime.datetime.strptime(competition_dict['start_date'],
                                            '%Y-%m-%d').date()
    end_date = datetime.datetime.strptime(competition_dict['end_date'],
                                          '%Y-%m-%d').date()

    competition_proto.schedule.start_date = competition_dict['start_date']
    competition_proto.schedule.number_of_days = int(
        (end_date - start_date).total_seconds() /
        datetime.timedelta(days=1).total_seconds() + 1)

    competition = Competition(id=competition_proto.id)
    competition.base64 = base64.urlsafe_b64encode(competition_proto.SerializeToString())
    return competition

  @staticmethod
  def FromWcifJson(competition_json):
    competition_proto = json_format.Parse(
        competition_json, competition_pb2.Competition(),
        ignore_unknown_fields=True)

    competition = Competition(id=competition_proto.id)
    competition.base64 = base64.urlsafe_b64encode(competition_proto.SerializeToString())
    competition.enabled = True
    return competition

  def Proto(self):
    competition_proto = competition_pb2.Competition()
    competition_proto.ParseFromString(base64.urlsafe_b64decode(str(self.base64)))
    return competition_proto

  def ThinProto(self):
    proto = self.Proto()
    del proto.persons[:]
    del proto.events[:]
    del proto.schedule.venues[:]
    return proto

  def FormatDates(self):
    proto = self.Proto()
    start_date = datetime.datetime.strptime(proto.schedule.start_date, '%Y-%m-%d').date()
    end_date = start_date + datetime.timedelta(days=proto.schedule.number_of_days)

    if start_date == end_date:
      return start_date.strftime('%B %-d, %Y')
    elif start_date.year != end_date.year:
      return ('%s &ndash; %s' % (start_date.strftime('%B %-d, %Y'),
                                 end_date.strftime('%B %-d, %Y')))
    elif start_date.month != end_date.month:
      return ('%s &ndash; %s' % (start_date.strftime('%B %-d'),
                                 end_date.strftime('%B %-d, %Y')))
    else:
      return ('%s &ndash; %s' % (start_date.strftime('%B %-d'),
                                 end_date.strftime('%-d, %Y')))
