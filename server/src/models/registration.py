from google.appengine.ext import ndb

from src.models.competition import Competition
from src.models.user import User

class Registration(ndb.Model):
  user = ndb.KeyProperty(kind=User)
  competition = ndb.KeyProperty(kind=Competition)
  name = ndb.StringProperty()
  is_admin = ndb.BooleanProperty()

  @staticmethod
  def Id(competition_id, competitor_id):
    return '%s_%d' % (competition_id, competitor_id)
