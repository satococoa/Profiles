class Twitter
  def initialize
    @account_store = ACAccountStore.new
  end

  def can_access?
    SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
  end

  def timeline(username)
    if can_access?
      account_type = @account_store.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
      @account_store.requestAccessToAccountsWithType(account_type,
        options: nil,
        completion:lambda{|granted, error|
          if granted
            accounts = @account_store.accountsWithAccountType(account_type)
            # debug
            accounts.each do |ac|
              p ac.username
              p ac.accountDescription
            end
            url = NSURL.URLWithString('https://api.twitter.com/1.1/statuses/user_timeline.json')
            params = {
              screen_name: username,
              include_rts: '0',
              trim_user: '1',
              count: '1'
            }
            request = SLRequest.requestForServiceType(SLServiceTypeTwitter,
              requestMethod:SLRequestMethodGET,
              URL:url,
              parameters:params
            )
            request.setAccount(accounts.last)
            request.performRequestWithHandler(
              lambda{|data, response, error| 
                if data
                  if response.statusCode >= 200 && response.statusCode < 300
                    data = BW::JSON.parse(data)
                    p data
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
    else
      []
    end
  end
end