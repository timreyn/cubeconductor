import json

from google.appengine.ext import ndb

from src.handlers.base import BaseHandler
from src.models.registration import Registration


# This serves a subset of the data available at /api/v0/me on the WCA website.
class MyCompetitionsApiHandler(BaseHandler):
  def get(self):
    self.response.content_type = 'application/json'
    registrations = Registration.query(Registration.user == self.user.key).fetch()
    competitions = ndb.get_multi([registration.competition for registration in registrations])
    self.response.write(json.dumps([
        {
            'competition': competition.ToDict(),
            'is_admin': registration.is_admin,
        } for competition, registration in zip(competitions, registrations)
    ]))

  def LoginRequired(self):
    return True
