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

class EditCompetitionDataHandler(OAuthBaseHandler):
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

    template = JINJA_ENVIRONMENT.get_template('edit_competition_data.html')
    competition = Competition.get_by_id(competition_id)
    competition_wcif = json.loads(competition.competition_wcif)
    self.response.write(template.render({
        'c': common.Common(self),
        'code': self.auth_token,
        'competition_id': competition_id,
        'schedule_data': json.dumps(competition_wcif['schedule'], indent=2),
        'persons_data': json.dumps(competition_wcif['persons'], indent=2),
        'events_data': json.dumps(competition_wcif['events'], indent=2),
    }))

  def post(self, competition_id):
    body = self.request.POST['data']
    self.auth_token = self.request.POST['code']

    response = self.PatchWcaApi('/api/v0/competitions/%s/wcif/schedule' % competition_id, body)
    response_json = json.loads(response)

    self.redirect_to('competition_update', competition_id=competition_id)
