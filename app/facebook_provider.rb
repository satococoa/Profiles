class FacebookProvider < Provider
  def initialize
    @account_type_identifier = ACAccountTypeIdentifierFacebook
    @service_type = SLServiceTypeFacebook
    @request_options = {
      ACFacebookAppIdKey => '428001310620805',
      ACFacebookPermissionsKey => ['email'],
      ACFacebookAudienceKey => ACFacebookAudienceOnlyMe
    }
  end

  def profile(username)
    url = 'https://graph.facebook.com/me'
    params = {}
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