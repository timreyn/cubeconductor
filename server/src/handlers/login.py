import datetime
import json
import urllib

from src.handlers.base import BaseHandler
from src.handlers.oauth import OAuthBaseHandler
from src.models.user import User

class LoginHandler(OAuthBaseHandler):
  def get(self):
    if not self.request.get('code'):
      redirect_url = self.request.get('target') or self.request.referer or '/'
      self.redirect('/authenticate?' + urllib.urlencode({
          'scope': 'public email',
          'callback': self.request.path,
          'handler_data': redirect_url,
      }))
      return

    OAuthBaseHandler.GetTokenFromCode(self)
    if not self.auth_token:
      return

    response = self.GetWcaApi('/api/v0/me')
    if response.status != 200:
      self.response.set_status(response.status)
      logging.error('Error from WCA: ' + self.response.read())
      return

    wca_info = json.loads(response.read())['me']
    self.session['wca_account_number'] = wca_info['id']
    self.session['login_time'] = (
        datetime.datetime.now() - datetime.datetime.utcfromtimestamp(0)).total_seconds()
    user = User.get_by_id(wca_info['id']) or User(id=wca_info['id'])

    for prop in ['wca_id', 'name', 'email', 'delegate_status']:
      prop_val = wca_info.get(prop)
      if prop_val:
        setattr(user, prop, prop_val)
      else:
        delattr(user, prop)

    avatar_url = wca_info.get('avatar', {}).get('thumb_url')
    if avatar_url:
      user.avatar_url = avatar_url
    else:
      del user.avatar_url

    user.last_login = datetime.datetime.now()
    user.put()

    self.redirect(str(self.handler_data))

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
