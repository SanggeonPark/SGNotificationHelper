Pod::Spec.new do |s|
  s.name         = "SGNotificationHelper"
  s.version      = "0.1.4"
  s.summary      = "iOS Remote Notification and UILocalNotification Helper"
  s.homepage     = "https://github.com/SanggeonPark/SGNotificationHelper"

  s.source       = { :git => 'https://github.com/SanggeonPark/SGNotificationHelper.git', :tag => s.version.to_s }
  s.authors      = { "Sanggeon Park" => "gunnih@gmail.com" }

  s.ios.deployment_target = '6.0'
  
  s.requires_arc = true 

  s.license	 = { :type => 'BSD-new', :file => 'LICENSE.txt' }

  s.public_header_files = 'SGLocalNotificationHelper/*.h'

  s.default_subspecs = 'SGNotificationHelper'

  s.subspec 'SGNotificationHelper' do |sh|
    sh.source_files  = 'SGLocalNotificationHelper/*.{h,m}'
  end

end
