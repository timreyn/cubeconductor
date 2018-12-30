import base64
import json

from google.protobuf import json_format

from src.handlers.base import BaseHandler
from src.models.competition import Competition
from src.api.wcif import competition_pb2


class CompetitionProtoHandler(BaseHandler):
  def get(self, competition_id):
    competition = Competition.get_by_id(competition_id)
    self.response.content_type = (
        'application/protobuf; proto=cubeconductor.api.wcif.Competition')
    self.response.write(competition.base64)

  def LoginRequired(self):
    return True
