class Provider
  def account_store
    @@account_store ||= ACAccountStore.new
  end

  def account_type
    @account_type ||= account_store.accountTypeWithAccountTypeIdentifier(@account_type_identifier)
  end

  def can_access?
    SLComposeViewController.isAvailableForServiceType(@service_type)
  end

  def accounts
    account_store.accountsWithAccountType(account_type)
  end

  private
  def send_request(url_string, method, params, &block)
    return unless can_access?
    account_store.requestAccessToAccountsWithType(account_type,
      options:@request_options,
      completion:lambda {|granted, error|
        methods = {
          get: SLRequestMethodGET,
          post: SLRequestMethodPOST,
          delete: SLRequestMethodDELETE
        }
        if granted
          url = NSURL.URLWithString(url_string)
          request = SLRequest.requestForServiceType(
            @service_type,
            requestMethod:methods[method],
            URL:url,
            parameters:params
          )
          request.account = accounts.last
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
          Dispatch::Queue.main.async {
            App.alert(error.localizedDescription)
          }
        end
      }
    )
  end
end