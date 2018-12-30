import base64

from google.appengine.ext import ndb
from google.protobuf import json_format

from src.api import user_pb2


class User(ndb.Model):
  base64 = ndb.TextProperty()

  delegate_status = ndb.StringProperty()

  last_login = ndb.DateTimeProperty()

  def Proto(self):
    user_proto = user_pb2.User()
    user_proto.ParseFromString(base64.urlsafe_b64decode(str(self.base64)))
    return user_proto

  def FromDict(self, wca_info):
    user_proto = json_format.Parse(
        wca_info, user_pb2.User(), ignore_unknown_fields=True)

    self.base64 = base64.urlsafe_b64encode(user_proto.SerializeToString())
    self.enabled = True
