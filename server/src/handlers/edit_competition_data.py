import json
import urllib
import webapp2

from google.appengine.ext import ndb
from google.protobuf import json_format

from src import common
from src.models.competition import Competition
from src.models.refresh_token import RefreshToken
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

    response = self.GetWcaApi('/api/v0/competitions/%s/wcif' % competition_id)
    response_json = json.loads(response)

    template = JINJA_ENVIRONMENT.get_template('edit_competition_data.html')
    self.response.write(template.render({
        'c': common.Common(self),
        'competition_id': competition_id,
        'schedule_data': json.dumps(response_json['schedule'], indent=2, sort_keys=True),
        'persons_data': json.dumps(response_json['persons'], indent=2, sort_keys=True),
        'events_data': json.dumps(response_json['events'], indent=2, sort_keys=True),
    }))

  def post(self, competition_id):
    body = self.request.POST['data']
    refresh_token = RefreshToken.get_by_id(self.user.key.id())
    self.GetTokenFromRefreshToken(refresh_token)

    response = self.PatchWcaApi('/api/v0/competitions/%s/wcif/%s' %
                                    (competition_id, self.request.POST['type']),
                                body)

    self.redirect_to('competition_update', competition_id=competition_id)
