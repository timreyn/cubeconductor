import webapp2

from src import config
from src.handlers.api.v0.me import MeHandler
from src.handlers.login import LoginHandler
from src.handlers.login import LogoutHandler
from src.handlers.oauth import AuthenticateHandler
from src.handlers.oauth import OAuthCallbackHandler

app = webapp2.WSGIApplication([
  webapp2.Route('/authenticate', handler=AuthenticateHandler),
  webapp2.Route('/login', handler=LoginHandler, name='login'),
  webapp2.Route('/logout', handler=LogoutHandler, name='logout'),
  webapp2.Route('/oauth_callback', handler=OAuthCallbackHandler),
  webapp2.Route('/api/v0/me', handler=MeHandler),
], config=config.GetAppConfig())
