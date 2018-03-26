from google.appengine.ext import ndb

from src.models.user import User

class RefreshToken(ndb.Model):
  user = ndb.KeyProperty(kind=User)
  token = ndb.StringProperty()
