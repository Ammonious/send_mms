#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint send_mms.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'send_mms'
  s.version          = '0.0.1'
  s.summary          = 'A Plugin that allows you to attach an image as MMS with the default messaging app'
  s.description      = <<-DESC
A Plugin that allows you to attach media as MMS.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Scheme Creative' => 'Ammon@schemecreative.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
