Pod::Spec.new do |s|
  s.name         = "SGNotificationHelper"
  s.version      = "0.1.1"
  s.summary      = "iOS Remote Notification and UILocalNotification Helper"
  s.homepage     = "https://github.com/SanggeonPark/SGNotificationHelper"

  s.source       = { :git => 'https://github.com/SanggeonPark/SGNotificationHelper.git', :tag => s.version.to_s }
  s.authors      = { "François Benaiteau" => "francois.benaiteau@sinnerschrader-mobile.com" }

  s.ios.deployment_target = '7.0'
  s.requires_arc = true 
  s.license	 = { :type => 'BSD-new', :file => 'LICENSE.txt' }
end
