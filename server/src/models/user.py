from google.appengine.ext import ndb


class User(ndb.Model):
  wca_id = ndb.StringProperty()
  name = ndb.StringProperty()
  email = ndb.StringProperty()
  photo_url = ndb.StringProperty()

  delegate_status = ndb.StringProperty()

  last_login = ndb.DateTimeProperty()
