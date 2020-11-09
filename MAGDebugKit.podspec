#
# Be sure to run `pod lib lint MAGDebugKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MAGDebugKit'
  s.version          = '0.9.0'
  s.summary          = 'Developers Kit for convenient testing and QA.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Developers Kit for convenient iOS App testing and QA.'
  s.homepage         = 'https://github.com/dcc-llc/MAGDebugKit'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author           = { 'Evgeniy Stepanov' => 'stepanov@magora.systems' }
  s.source           = { :git => 'https://github.com/dcc-llc/MAGDebugKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'MAGDebugKit/Classes/**/*'
  s.resource_bundles = {
    'MAGDebugKit' => ['MAGDebugKit/Assets/*.xib']
  }

  s.dependency 'libextobjc', '~> 0.4'

end
