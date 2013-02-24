class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @twitter = Twitter.new
    @twitter.timeline('satococoa')
    true
  end
end
