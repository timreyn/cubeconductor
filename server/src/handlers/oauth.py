import httplib
import json
import logging
import urllib
import webapp2

from google.appengine.api import urlfetch

from src.handlers.base import BaseHandler
from src.models.app_settings import AppSettings
from src.models.refresh_token import RefreshToken

def strip(url):
  for prefix in ['http://', 'https://']:
    if url.startswith(prefix):
      return url[len(prefix):]
  return url

class AuthenticateHandler(BaseHandler):
  def get(self):
    app_settings = AppSettings.Get()
    redirect_uri = self.request.host_url + '/oauth_callback'
    
    params = {
        'client_id': app_settings.wca_oauth_client_id,
        'response_type': 'code',
        'redirect_uri': redirect_uri,
        'state': json.dumps({
            'handler_data': self.request.get('handler_data'),
            'oauth_redirect_uri': redirect_uri,
            'actual_redirect_uri': self.request.get('callback'),
        }),
        'scope': 'public email manage_competitions',
    }

    oauth_url = app_settings.wca_website + '/oauth/authorize?' + urllib.urlencode(params)
    self.redirect(oauth_url)

class OAuthCallbackHandler(BaseHandler):
  def get(self):
    state = json.loads(self.request.get('state'))
    self.redirect(str(state['actual_redirect_uri']) + '?' +
                  self.request.query_string)

class OAuthBaseHandler(BaseHandler):
  # Subclasses should first call OAuthBaseHandler.GetTokenFromCode(self), then
  # check if self.auth_token is None.  If so, they must return early.
  def GetTokenFromCode(self):
    self.auth_token = None
    code = self.request.get('code')
    if not code:
      self.response.set_status(400)
      return

    state = json.loads(self.request.get('state'))
    self.handler_data = state['handler_data']
    app_settings = AppSettings.Get()

    # Get OAuth token.
    post_data = {
        'grant_type': 'authorization_code',
        'code': code,
        'client_id': app_settings.wca_oauth_client_id,
        'client_secret': app_settings.wca_oauth_client_secret,
        'redirect_uri': state['oauth_redirect_uri'],
    }
    conn = httplib.HTTPSConnection(strip(app_settings.wca_website) + '/oauth/token')
    conn.request('POST', '', urllib.urlencode(post_data), {})
    response = conn.getresponse()
    if response.status != 200:
      self.response.set_status(response.status)
      logging.error('Error from WCA OAuth: ' + response.read())
      return
    response_json = json.loads(response.read())
    self.auth_token = response_json['access_token']
    # The handler may choose to save this for later use.
    self.refresh_token = response_json['refresh_token']
    if self.user:
      refresh_token = RefreshToken(id=self.user.key.id())
      refresh_token.token = response_json['refresh_token']
      refresh_token.user = self.user.key
      refresh_token.put()

  # Subclasses may use GetFromRefreshToken instead if they're holding a
  # RefreshToken.  This fetches an auth token and updates the refresh token.
  def GetTokenFromRefreshToken(self, refresh_token):
    app_settings = AppSettings.Get()
    post_data = {
        'grant_type': 'refresh_token',
        'refresh_token': refresh_token.token,
        'client_id': app_settings.wca_oauth_client_id,
        'client_secret': app_settings.wca_oauth_client_secret,
    }
    conn = httplib.HTTPSConnection(strip(app_settings.wca_website) + '/oauth/token')
    conn.request('POST', '', urllib.urlencode(post_data), {})
    response = conn.getresponse()
    if response.status != 200:
      self.response.set_status(response.status)
      logging.error('Error from WCA OAuth: ' + response.read())
      return
    response_json = json.loads(response.read())
    self.auth_token = response_json['access_token']
    refresh_token.token = response_json['refresh_token']
    refresh_token.put()

  def GetWcaApi(self, path):
    if path[0] != '/':
      path = '/' + path
    # OAuth token obtained, now read information using the person's token.
    headers = {'Authorization': 'Bearer ' + self.auth_token}
    url = AppSettings.Get().wca_website + path
    result = urlfetch.fetch(url=url, headers=headers)
    return result.content

class LogoutHandler(BaseHandler):
  def get(self):
    if 'wca_account_number' in self.session:
      del self.session['wca_account_number']
    if 'login_time' in self.session:
      del self.session['login_time']

    if self.request.referer:
      self.redirect(self.request.referer)
    else:
      self.redirect('/')
