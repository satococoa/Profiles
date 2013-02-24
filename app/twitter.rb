class Twitter
  def account_store
    @account_store ||= ACAccountStore.new
  end

  def account_type
    @account_type ||= account_store.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
  end

  def accounts
    account_store.accountsWithAccountType(account_type)
  end

  def can_access?
    SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
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

  private
  def send_request(url_string, method, params, &block)
    return unless can_access?
    account_store.requestAccessToAccountsWithType(account_type,
      options:nil,
      completion:lambda {|granted, error|
        methods = {
          get: SLRequestMethodGET,
          post: SLRequestMethodPOST,
          delete: SLRequestMethodDELETE
        }
        if granted
          url = NSURL.URLWithString(url_string)
          request = SLRequest.requestForServiceType(
            SLServiceTypeTwitter,
            requestMethod:methods[method],
            URL:url,
            parameters:params
          )
          request.setAccount(accounts.last)
          request.performRequestWithHandler(
            lambda{|data, response, error| 
              if data
                if response.statusCode >= 200 &&
                  response.statusCode < 300
                  data = BW::JSON.parse(data)
                  block.call(data) unless block.nil?
                else
                  p "The response status code is %d" % response.statusCode
                end
              end
            }
          )
        else
          App.alert(error.localizedDescription)
        end
      }
    )
  end

end