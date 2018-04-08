import json

from src.handlers.base import BaseHandler
from src.models.competition import Competition


# This serves a subset of the data available at /api/v0/me on the WCA website.
class CompetitionWcifHandler(BaseHandler):
  def get(self, competition_id):
    competition = Competition.get_by_id(competition_id)
    self.response.content_type = 'application/json'
    self.response.write(competition.competition_wcif)

  def LoginRequired(self):
    return True
