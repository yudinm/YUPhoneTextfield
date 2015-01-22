Pod::Spec.new do |s|
  s.name         = "YUPhoneTextfield"
  s.version      = "0.0.2"
  s.summary      = "A class for formatting input phone number."
  s.homepage     = "https://github.com/yudinm/YUPhoneTextfield"
  s.screenshots  = "https://dl.dropboxusercontent.com/u/6458378/screenshot_yuphonetextfield.png"
  s.license      = {:type => "MIT", :file => "LICENSE"}
  s.author		 = {"Michael Yudin" => "michael.s.yudin@gmail.com"}
  s.social_media_url   = "http://twitter.com/yudin_mich"
  s.platform     = :ios, "7.1"
  s.source       = {:git => "https://github.com/yudinm/YUPhoneTextfield.git", :tag => "0.0.2"}
  s.source_files  = "YUPhoneTextfield/Formatter/*.{h,m}"
  s.frameworks = "Foundation"
  s.requires_arc = true
end
