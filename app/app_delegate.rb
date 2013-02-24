class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @twitter = TwitterProvider.new
    # @twitter.timeline('satococoa')
    @twitter.profile('satococoa')
    @facebook = FacebookProvider.new
    # @facebook.timeline('me')
    @facebook.profile('me')
    true
  end
end
