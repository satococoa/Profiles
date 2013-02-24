class TwitterProvider < Provider
  def initialize
    @account_type_identifier = ACAccountTypeIdentifierTwitter
    @service_type = SLServiceTypeTwitter
  end

  def profile(username)
    url = 'http://api.twitter.com/1.1/users/show.json'
    params = {
      screen_name: username
    }
    send_request(url, :get, params) do |data|
      p data
    end
  end

  def timeline(username)
    url = 'https://api.twitter.com/1.1/statuses/user_timeline.json'
    params = {
      screen_name: username,
      include_rts: '0',
      trim_user: '1',
      count: '1'
    }
    send_request(url, :get, params) do |data|
      p data
    end
  end
end