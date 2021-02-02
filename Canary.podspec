#
# Be sure to run `pod lib lint Canary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Canary'
  s.version          = '0.6.2'
  s.summary          = 'Canary is SDK For CanaryService.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/BinaryParadise/CanaryService'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rake Yang' => 'fenglaijun@gmail.com' }
  s.source           = { :git => 'https://github.com/BinaryParadise/CanaryService.git', :tag => s.version.to_s }
  
  s.swift_version = '4.2'

  s.ios.deployment_target = '9.0'
  
  s.pod_target_xcconfig = { "DEFINES_MODULE" => "YES" }
  s.user_target_xcconfig = { "DEFINES_MODULE" => "YES" }
  
  s.resource = 'iOS/Assets/Canary.bundle'
  s.user_target_xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'CANARY_ENABLE=1', "OTHER_SWIFT_FLAGS" => "-D CANARY_ENABLE"}

  s.source_files = 'iOS/CanarySwift/**/*'
  s.dependency 'SwifterSwift'
  s.dependency 'SnapKit'
  s.dependency 'SwiftyJSON'
  s.dependency 'Starscream', '~> 4.0'

end
