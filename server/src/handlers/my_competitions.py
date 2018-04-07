import datetime
import json
import urllib
import webapp2

from google.appengine.ext import ndb

from src import common
from src.models.competition import Competition
from src.models.registration import Registration
from src.handlers.oauth import OAuthBaseHandler
from src.jinja import JINJA_ENVIRONMENT

class MyCompetitionsHandler(OAuthBaseHandler):
  def get(self):
    template = JINJA_ENVIRONMENT.get_template('my_competitions.html')
    if not self.user:
      self.response.write(template.render({
          'c': common.Common(self),
      }))
      return

    if not self.request.get('code'):
      self.redirect('/authenticate?' + urllib.urlencode({
          'callback': webapp2.uri_for('my_competitions', _full=True),
      }))
      return

    OAuthBaseHandler.GetTokenFromCode(self)
    if not self.auth_token:
      return

    response = self.GetWcaApi(
        '/api/v0/competitions?managed_by_me=true&start=%s' %
            (datetime.datetime.now() - datetime.timedelta(days=30)).isoformat())
    response_json = json.loads(response)

    my_registrations = Registration.query(Registration.user == self.user.key).fetch()
    my_competitions = ndb.get_multi([reg.competition for reg in my_registrations])
    my_competitions_by_id = {competition.key.id() : competition
                             for competition in my_competitions}

    managed_competitions = []
    for competition_dict in response_json:
      competition = (my_competitions_by_id[competition_dict['id']] or
                     Competition(id=competition_dict['id']))
      competition.FromCompetitionSearch(competition_dict)
      managed_competitions.append(competition)

    self.response.write(template.render({
        'c': common.Common(self),
        'managed_competitions': managed_competitions,
        'my_competitions': my_competitions,
    }))
    return
