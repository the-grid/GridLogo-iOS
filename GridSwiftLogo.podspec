Pod::Spec.new do |s|
  s.name         = "GridSwiftLogo"
  s.version      = "3.0.5"
  s.summary      = "An animated Grid Logo helper."
  s.homepage     = "https://github.com/the-grid/GridSwiftLogo"
  s.license     = { :type => "MIT" }
  s.author             = { "Nick Velloff" => "nick.velloff@gmail.com" }
  s.social_media_url   = "https://twitter.com/nickvelloff"
  s.platform     = :ios
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/the-grid/GridSwiftLogo.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "GridLogo/**/*.swift"
  s.requires_arc = true
end
