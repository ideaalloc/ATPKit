#
# Be sure to run `pod lib lint ATPKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.swift_version    = '4.1.2'
  s.name             = 'ATPKit'
  s.version          = '1.0.4'
  s.summary          = 'ATPKit'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ATP Kit is for Atlas Protocol Targeting Interactive Element Development
                       DESC

  s.homepage         = 'https://github.com/ideaalloc/ATPKit.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'LGPL', :file => 'LICENSE' }
  s.author           = { 'Bill Lv' => 'bill.lv@atlasp.io' }
  s.source           = { :git => 'https://github.com/ideaalloc/ATPKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ATPKit/**/*'
  s.exclude_files = 'ATPKit/**/Info.plist'
  
  # s.resource_bundles = {
  #   'ATPKit' => ['ATPKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pods/**/*.h'
  s.dependency 'Alamofire', '~> 4.7'
  s.dependency 'Renderer', '~> 1.1.0'
end

