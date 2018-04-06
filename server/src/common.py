import webapp2

class Common:
  def __init__(self, handler):
    self.uri_for = webapp2.uri_for
    self.user = handler.user
    self.uri = handler.request.url
