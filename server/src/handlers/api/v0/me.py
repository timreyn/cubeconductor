import json

from src.handlers.base import BaseHandler


# This serves a subset of the data available at /api/v0/me on the WCA website.
class MeHandler(BaseHandler):
  def get(self):
    self.response.content_type = 'application/json'
    self.response.write(json.dumps(self.user.ToDict()))

  def LoginRequired(self):
    return True
