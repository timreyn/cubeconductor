import base64

from google.appengine.ext import ndb

from src.api import my_competitions_pb2
from src.handlers.base import BaseHandler
from src.models.registration import Registration


class MyCompetitionsApiHandler(BaseHandler):
  def get(self):
    self.response.content_type = 'application/protobuf; proto=cubeconductor.api.MyCompetitions'
    registrations = Registration.query(Registration.user == self.user.key).fetch()
    competitions = ndb.get_multi([registration.competition for registration in registrations])

    my_competitions = my_competitions_pb2.MyCompetitions()
    for competition, registration in zip(competitions, registrations):
      entry = my_competitions.entries.add()
      entry.competition.CopyFrom(competition.ThinProto())
      entry.is_admin = registration.is_admin
    
    self.response.write(base64.urlsafe_b64encode(my_competitions.SerializeToString()))

  def LoginRequired(self):
    return True
