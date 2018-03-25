from google.appengine.ext import ndb

class AppSettings(ndb.Model):
  session_secret_key = ndb.StringProperty(default='ccac2393c2537d489fa7e8a223be0d7d')
  wca_oauth_client_id = ndb.StringProperty(default='example-application-id')
  wca_oauth_client_secret = ndb.StringProperty(default='example-secret')

  wca_website = ndb.StringProperty(default='https://staging.worldcubeassociation.org/')

  @staticmethod
  def Get():
    return AppSettings.get_by_id('1') or AppSettings(id='1')
