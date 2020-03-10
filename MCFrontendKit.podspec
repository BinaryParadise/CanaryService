#
# Be sure to run `pod lib lint MCFrontendService.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MCFrontendKit'
  s.version          = '0.3.0'
  s.summary          = 'A short description of MCFrontendService.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/BinaryParadise/MCFrontendService'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rake Yang' => 'fenglaijun@gmail.com' }
  s.source           = { :git => 'https://github.com/BinaryParadise/MCFrontendService.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.osx.deployment_target = '10.10'
  s.ios.deployment_target = '9.0'

  s.ios.source_files = ['iOS/MCFrontendKit/*.{h,m}',
                        'iOS/MCFrontendKit/Internal/**/*',
                        'iOS/MCFrontendKit/iOS/*']
  s.osx.source_files = ['iOS/MCFrontendKit/*.{h,m}',
                        'iOS/MCFrontendKit/Internal/**/*',
                        'iOS/MCFrontendKit/OSX/*']
  s.private_header_files = 'iOS/MCFrontendKit/Internal/**/*.h'
  
   s.osx.resource_bundles = {
     'MCFrontendKit' => ['iOS/MCFrontendKit/OSX/Assets/*']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'MJExtension'
  s.ios.dependency 'CocoaLumberjack', '3.5.2'
  s.osx.dependency 'CocoaLumberjack/Swift', '3.5.2'
  s.dependency 'SAMKeychain', '~> 1.5'
  s.dependency 'SocketRocket', '~> 0.5'

end
