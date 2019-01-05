import collections
import datetime
import json
import random
import urllib
import webapp2

from google.appengine.ext import ndb

from src import common
from src.api.wcif import activity_pb2
from src.api.wcif import assignment_pb2
from src.models.competition import Competition
from src.models.registration import Registration
from src.models.user import User
from src.handlers.oauth import OAuthBaseHandler
from src.jinja import JINJA_ENVIRONMENT

def AddFakeAssignments(proto):
  next_assignment_id = 1000
  activities_by_round = collections.defaultdict(list)
  for venue in proto.schedule.venues:
    for room in venue.rooms:
      for activity in room.activities:
        #del activity.child_activities[:]
        start_time = datetime.datetime.strptime(activity.start_time, '%Y-%m-%dT%H:%M:%SZ')
        end_time = datetime.datetime.strptime(activity.end_time, '%Y-%m-%dT%H:%M:%SZ')
        group_length = (end_time - start_time) / 4
        for i in range(5):
          activity.child_activities.add(
              id=next_assignment_id,
              start_time=(start_time + i * group_length).isoformat(),
              end_time=(start_time + (i + 1) * group_length).isoformat(),
              activity_code=activity.activity_code + "-g%d" % (i + 1))
          activities_by_round[activity.activity_code].append(next_assignment_id)
          next_assignment_id += 1
  for person in proto.persons:
    for r, activities in activities_by_round.iteritems():
      random.shuffle(activities)
      person.assignments.add(
          activity_id=activities[0],
          assignment_code='competitor')
      person.assignments.add(
          activity_id=activities[1],
          assignment_code='staff-judge')
      person.assignments.add(
          activity_id=activities[2],
          assignment_code='staff-scrambler')
      person.assignments.add(
          activity_id=activities[3],
          assignment_code='staff-runner')


class UpdateCompetitionHandler(OAuthBaseHandler):
  def get(self, competition_id):
    if not self.user:
      template = JINJA_ENVIRONMENT.get_template('error.html')
      self.response.write(template.render({
          'c': common.Common(self),
          'error_message': 'Please log in.',
      }))
      return

    if not self.request.get('code'):
      self.redirect('/authenticate?' + urllib.urlencode({
          'callback': self.request.url,
      }))
      return

    OAuthBaseHandler.GetTokenFromCode(self)
    if not self.auth_token:
      return

    response = self.GetWcaApi('/api/v0/competitions/%s/wcif' % competition_id)
    response_json = json.loads(response)

    competition = Competition.FromWcifJson(response)
    competition.put()
    proto = competition.Proto()

    AddFakeAssignments(proto)

    new_competitors = {person['wcaUserId'] : person for person in response_json['persons']}
    old_competitors = {registration.user.id() : registration for registration in
                       Registration.query(Registration.competition == competition.key).iter()}

    to_put = []
    for competitor_id, competitor_dict in new_competitors.iteritems():
      competitor = (old_competitors.pop(competitor_id, None) or
                    Registration(id=Registration.Id(competition_id, competitor_id)))
      competitor.competition = competition.key
      competitor.user = ndb.Key(User, competitor_id)
      competitor.name = competitor_dict['name']
      competitor.is_admin = (competitor_dict.get('delegatesCompetition', False) or
                             competitor_dict.get('organizesCompetition', False) or
                             'delegate' in competitor_dict['registration'].get('roles', []) or
                             'organizer' in competitor_dict['registration'].get('roles', []))
      to_put.append(competitor)
    ndb.put_multi(to_put)

    ndb.delete_multi([ndb.Key(Registration, Registration.Id(competition_id, competitor_id))
                      for competitor_id in old_competitors.iterkeys()])

    self.redirect_to('my_competitions')
    return
