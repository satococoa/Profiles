class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @twitter = Twitter.new
    @twitter.timeline('satococoa')
    @twitter.profile('satococoa')
    true
  end
end
