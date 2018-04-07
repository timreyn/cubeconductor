import datetime

from google.appengine.ext import ndb

class Competition(ndb.Model):
  name = ndb.StringProperty()
  short_name = ndb.StringProperty()

  city = ndb.StringProperty()
  country_iso2 = ndb.StringProperty()

  start_date = ndb.DateProperty()
  end_date = ndb.DateProperty()

  def FromDict(self, competition_dict):
    self.name = competition_dict['name']
    self.short_name = competition_dict['short_name']

    self.city = competition_dict['city']
    self.country_iso2 = competition_dict['country_iso2']

    self.start_date = datetime.datetime.strptime(competition_dict['start_date'],
                                                 '%Y-%m-%d').date()
    self.end_date = datetime.datetime.strptime(competition_dict['end_date'],
                                               '%Y-%m-%d').date()

  def FormatDates(self):
    if self.start_date == self.end_date:
      return self.start_date.strftime('%B %-d, %Y')
    elif self.start_date.year != self.end_date.year:
      return ('%s &ndash; %s' % (self.start_date.strftime('%B %-d, %Y'),
                                 self.end_date.strftime('%B %-d, %Y')))
    elif self.start_date.month != self.end_date.month:
      return ('%s &ndash; %s' % (self.start_date.strftime('%B %-d'),
                                 self.end_date.strftime('%B %-d, %Y')))
    else:
      return ('%s &ndash; %s' % (self.start_date.strftime('%B %-d'),
                                 self.end_date.strftime('%-d, %Y')))
