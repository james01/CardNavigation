Pod::Spec.new do |s|
  s.name             = "CardNavigation"
  s.version          = "1.1.0"
  s.summary          = "A navigation controller that displays its view controllers as an interactive stack of cards."
  s.homepage         = "https://github.com/james01/CardNavigation"
  s.screenshots      = "https://raw.githubusercontent.com/james01/CardNavigation/main/Docs/Images/Screen.gif"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "James Randolph" => "jwrand16@gmail.com" }
  s.social_media_url = "https://twitter.com/jamesrandolph01"
  s.platform         = :ios, "11.0"
  s.source           = { :git => "https://github.com/james01/CardNavigation.git", :tag => "#{s.version}" }
  s.source_files     = "Sources/**/*.{swift}"
  s.frameworks       = "UIKit"
  s.swift_version    = "5.3"
end
