import datetime
import json

from google.appengine.ext import ndb

# Drop fields we don't care to save.
def StripWcif(competition_dict):
  for event in competition_dict['events']:
    event.pop('competitorLimit', None)
    event.pop('qualification', None)
    for r in event['rounds']:
      r.pop('results', None)
      r.pop('scrambleSetCount', None)
      r.pop('scrambleSets', None)

  def status(person):
    if 'registration' not in person:
      return 'n/a'
    if not person['registration']:
      return 'n/a'
    return person['registration'].get('status', 'n/a')

  competition_dict['persons'] = filter(
      lambda person: status(person) in ('accepted', 'n/a'),
      competition_dict['persons'])
  for person in competition_dict['persons']:
    person.pop('gender', None)
    person.pop('birthdate', None)
    person.pop('email', None)
    for best in person.get('personalBests', []):
      best.pop('worldRanking', None)
      best.pop('continentalRanking', None)
      best.pop('nationalRanking', None)
    registration = person['registration'] or {}
    registration.pop('status', None)
    registration.pop('guests', None)
    registration.pop('comments', None)

class Competition(ndb.Model):
  name = ndb.StringProperty()
  short_name = ndb.StringProperty()

  city = ndb.StringProperty()
  country_iso2 = ndb.StringProperty()

  start_date = ndb.DateProperty()
  end_date = ndb.DateProperty()

  competition_wcif = ndb.TextProperty()

  enabled = ndb.BooleanProperty()

  def FromCompetitionSearch(self, competition_dict):
    self.name = competition_dict['name']
    self.short_name = competition_dict['short_name']

    self.city = competition_dict['city']
    self.country_iso2 = competition_dict['country_iso2']

    self.start_date = datetime.datetime.strptime(competition_dict['start_date'],
                                                 '%Y-%m-%d').date()
    self.end_date = datetime.datetime.strptime(competition_dict['end_date'],
                                               '%Y-%m-%d').date()

  def FromWcifDict(self, competition_dict):
    self.name = competition_dict['name']
    self.short_name = competition_dict['shortName']

    self.start_date = datetime.datetime.strptime(
                          competition_dict['schedule']['startDate'],
                          '%Y-%m-%d').date()
    self.end_date = (self.start_date +
                     datetime.timedelta(days=competition_dict['schedule']['numberOfDays'] - 1))

    StripWcif(competition_dict)
    self.competition_wcif = json.dumps(competition_dict)
    self.enabled = True

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
