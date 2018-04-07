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

    new_competitors = {person['wcaUserId'] : person for person in response_json['persons']}
    old_competitors = {registration.user.id() : registration for registration in
                       Registration.query(Registration.competition == competition.key).iter()}

    to_put = []
    for competitor_id, competitor_dict in new_competitors.iteritems():
      competitor = (old_competitors.pop(competitor_id, None) or
                    Registration(id=Registration.Id(competition_id, competitor_id)))
      competitor.competition = competition.key
      competitor.user = ndb.Key(User, competitor_id)
      competitor.name = competitor_dict['name']
      competitor.is_admin = (competitor_dict.get('delegatesCompetition', False) or
                             competitor_dict.get('organizesCompetition', False) or
                             'delegate' in competitor_dict['registration'].get('roles', []) or
                             'organizer' in competitor_dict['registration'].get('roles', []))
      to_put.append(competitor)
    ndb.put_multi(to_put)

    ndb.delete_multi([ndb.Key(Registration, Registration.Id(competition_id, competitor_id))
                      for competitor_id in old_competitors.iterkeys()])

    self.redirect_to('my_competitions')
    return
