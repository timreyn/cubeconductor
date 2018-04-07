import datetime
import json
import urllib
import webapp2

from src import common
from src.models.competition import Competition
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
          'scope': 'public email manage_competitions',
          'callback': webapp2.uri_for('my_competitions', _full=True),
      }))
      return

    OAuthBaseHandler.GetTokenFromCode(self)
    if not self.auth_token:
      return

    response = self.GetWcaApi(
        '/api/v0/competitions?managed_by_me=true&start=%s' %
            (datetime.datetime.now() - datetime.timedelta(days=30)).isoformat())
    response_json = json.loads(response.read())

    managed_competitions = []
    for competition_dict in response_json:
      competition = Competition(id=competition_dict['id'])
      competition.FromDict(competition_dict)
      managed_competitions.append(competition)

    self.response.write(template.render({
        'c': common.Common(self),
        'managed_competitions': managed_competitions,
    }))
    return
