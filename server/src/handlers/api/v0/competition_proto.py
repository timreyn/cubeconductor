import base64
import json

from google.protobuf import json_format

from src.handlers.base import BaseHandler
from src.models.competition import Competition
from src.api.wcif import competition_pb2


class CompetitionProtoHandler(BaseHandler):
  def get(self, competition_id):
    competition = Competition.get_by_id(competition_id)
    self.response.content_type = 'application/protobuf'
    competition_proto = json_format.Parse(
        competition.competition_wcif, competition_pb2.Competition(),
        ignore_unknown_fields=True)

    self.response.write(base64.urlsafe_b64encode(competition_proto.SerializeToString()))

  def LoginRequired(self):
    return True
