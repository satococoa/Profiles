class FacebookProvider < Provider
  def initialize
    @account_type_identifier = ACAccountTypeIdentifierFacebook
    @service_type = SLServiceTypeFacebook
    @request_options = {
      ACFacebookAppIdKey => '428001310620805',
      ACFacebookPermissionsKey => ['public_actions', 'publish_stream', 'offline_access', 'email'],
      ACFacebookAudienceKey => ACFacebookAudienceOnlyMe
    }
  end

  def profile(username)
    url = 'http://api.twitter.com/1.1/users/show.json'
    params = {
      screen_name: username
    }
    send_request(url, :get, params) do |data|
      NSLog("%@", data)
    end
  end

  def timeline(username)
    url = 'https://graph.facebook.com/%s/feed' % username
    params = {}
    send_request(url, :get, params) do |data|
      NSLog("%@", data)
    end
  end
end