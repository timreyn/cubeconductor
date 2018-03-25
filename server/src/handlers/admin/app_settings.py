import webapp2

from src.jinja import JINJA_ENVIRONMENT
from src.models.app_settings import AppSettings

class AppSettingsHandler(webapp2.RequestHandler):
  def get(self):
    template = JINJA_ENVIRONMENT.get_template('admin/app_settings.html')
    self.response.write(template.render({
        'settings': AppSettings.Get(),
    }))

  def post(self):
    settings = AppSettings.Get()
    for prop, val in self.request.POST:
      if prop.startswith('PROP_'):
        setattr(settings, prop[5:], val)
    settings.put()
    
    template = JINJA_ENVIRONMENT.get_template('admin/app_settings.html')
    self.response.write(template.render({
        'settings': settings,
    }))
