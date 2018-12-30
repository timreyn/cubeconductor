import json

from src.handlers.base import BaseHandler


class MeHandler(BaseHandler):
  def get(self):
    self.response.content_type = 'application/protobuf; proto=cubeconductor.api.User'
    self.response.write(self.user.base64)

  def LoginRequired(self):
    return True
