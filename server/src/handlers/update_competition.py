import json
import urllib
import webapp2

from google.appengine.ext import ndb

from src import common
from src.models.competition import Competition
from src.models.registration import Registration
from src.models.user import User
from src.handlers.oauth import OAuthBaseHandler
from src.jinja import JINJA_ENVIRONMENT

class UpdateCompetitionHandler(OAuthBaseHandler):
  def get(self, competition_id):
    if not self.user:
      template = JINJA_ENVIRONMENT.get_template('error.html')
      self.response.write(template.render({
          'c': common.Common(self),
          'error_message': 'Please log in.',
      }))
      return

    if not self.request.get('code'):
      self.redirect('/authenticate?' + urllib.urlencode({
          'callback': self.request.url,
      }))
      return

    OAuthBaseHandler.GetTokenFromCode(self)
    if not self.auth_token:
      return

    response = self.GetWcaApi('/api/v0/competitions/%s/wcif' % competition_id)
    response_json = json.loads(response)

    competition = Competition.get_by_id(competition_id) or Competition(id=competition_id)
    competition.FromWcifDict(response_json)
    competition.put()

    new_competitor_ids = set(person['wcaUserId'] for person in response_json['persons'])
    old_competitor_ids = set(registration.user.id() for registration in
                             Registration.query(Registration.competition == competition.key).iter())

    to_put = []
    for competitor_id in new_competitor_ids - old_competitor_ids:
      competitor = Registration(id=Registration.Id(competition_id, competitor_id))
      competitor.competiiton = competition.key
      competitor.user = ndb.Key(User, competitor_id)
      to_put.append(competitor)
    ndb.put_multi(to_put)

    competitors_to_delete = old_competitor_ids - new_competitor_ids
    ndb.delete_multi([ndb.Key(Registration, Registration.Id(competition_id, competitor_id))
                      for competitor_id in old_competitor_ids - new_competitor_ids])

    self.redirect_to('my_competitions')
    return
