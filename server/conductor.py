import webapp2

from src import config
from src.handlers.api.v0.me import MeHandler
from src.handlers.basic import BasicHandler
from src.handlers.login import LoginHandler
from src.handlers.login import LogoutHandler
from src.handlers.my_competitions import MyCompetitionsHandler
from src.handlers.oauth import AuthenticateHandler
from src.handlers.oauth import OAuthCallbackHandler

app = webapp2.WSGIApplication([
  webapp2.Route('/', handler=BasicHandler('index.html')),
  webapp2.Route('/authenticate', handler=AuthenticateHandler),
  webapp2.Route('/login', handler=LoginHandler, name='login'),
  webapp2.Route('/logout', handler=LogoutHandler, name='logout'),
  webapp2.Route('/my_competitions', handler=MyCompetitionsHandler, name='my_competitions'),
  webapp2.Route('/oauth_callback', handler=OAuthCallbackHandler),
  webapp2.Route('/api/v0/me', handler=MeHandler),
], config=config.GetAppConfig())
