import webapp2

from src import config
from src.handlers.api.v0.competition_proto import CompetitionProtoHandler
from src.handlers.api.v0.me import MeHandler
from src.handlers.api.v0.my_competitions import MyCompetitionsApiHandler
from src.handlers.basic import BasicHandler
from src.handlers.login import LoginHandler
from src.handlers.login import LogoutHandler
from src.handlers.my_competitions import MyCompetitionsHandler
from src.handlers.oauth import AuthenticateHandler
from src.handlers.oauth import OAuthCallbackHandler
from src.handlers.edit_competition_data import EditCompetitionDataHandler
from src.handlers.update_competition import UpdateCompetitionHandler

app = webapp2.WSGIApplication([
  webapp2.Route('/', handler=BasicHandler('index.html')),
  webapp2.Route('/authenticate', handler=AuthenticateHandler),
  webapp2.Route('/login', handler=LoginHandler, name='login'),
  webapp2.Route('/login_flow_complete', handler=BasicHandler('login_flow_complete.html')),
  webapp2.Route('/logout', handler=LogoutHandler, name='logout'),
  webapp2.Route('/my_competitions', handler=MyCompetitionsHandler, name='my_competitions'),
  webapp2.Route('/oauth_callback', handler=OAuthCallbackHandler),
  webapp2.Route('/competition/<competition_id:.*>/update', handler=UpdateCompetitionHandler,
                name='competition_update'),
  webapp2.Route('/competition/<competition_id:.*>/edit', handler=EditCompetitionDataHandler,
                name='edit_competition_data'),
  webapp2.Route('/api/v0/competition/<competition_id:.*>/proto', handler=CompetitionProtoHandler),
  webapp2.Route('/api/v0/me', handler=MeHandler),
  webapp2.Route('/api/v0/my_competitions', handler=MyCompetitionsApiHandler),
], config=config.GetAppConfig())
