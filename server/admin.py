import webapp2

from src import config
from src.handlers.admin.app_settings import AppSettingsHandler

app = webapp2.WSGIApplication([
  webapp2.Route('/admin/app_settings', handler=AppSettingsHandler),
], config=config.GetAppConfig())
