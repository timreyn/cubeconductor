from google.appengine.ext import ndb


class User(ndb.Model):
  wca_id = ndb.StringProperty()
  name = ndb.StringProperty()
  email = ndb.StringProperty()
  avatar_url = ndb.StringProperty()
  avatar_thumb_url = ndb.StringProperty()

  delegate_status = ndb.StringProperty()

  last_login = ndb.DateTimeProperty()

  def FromDict(self, user_dict):
    for prop in ['wca_id', 'name', 'email', 'delegate_status']:
      prop_val = user_dict.get(prop)
      if prop_val:
        setattr(self, prop, prop_val)
      else:
        delattr(self, prop)

    for prop in ['url', 'thumb_url']:
      prop_val = user_dict.get('avatar', {}).get(prop)
      if prop_val:
        setattr(self, 'avatar_' + prop, prop_val)
      else:
        delattr(self, 'avatar_' + prop)

  def ToDict(self):
    out = {'id': self.key.id(),
           'avatar': {}}
    # Don't expose email, as this may be surfaced to other people.
    for prop in ['wca_id', 'name', 'delegate_status']:
      prop_val = getattr(self, prop, '')
      if prop_val:
        out[prop] = prop_val

    for prop in ['url', 'thumb_url']:
      prop_val = getattr(self, 'avatar_' + prop, '')
      if prop_val:
        out['avatar'][prop] = prop_val

    return out
