class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @twitter = TwitterProvider.new
    @twitter.timeline('satococoa')
    @twitter.profile('satococoa')
    true
  end
end
