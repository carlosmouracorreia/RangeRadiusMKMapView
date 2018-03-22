#
# Be sure to run `pod lib lint RangeRadiusMKMapView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RangeRadiusMKMapView'
  s.version          = '0.1.2'
  s.summary          = 'MKMapView subclass with custom range radius effect widget, a.k.a CircleOverlay'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
 This classs provides useful methods to easily create a range widget inside the MKMapView.
                       DESC

  s.homepage         = 'https://github.com/carlosmouracorreia/RangeRadiusMKMapView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'carlosmouracorreia' => 'pm.correia.carlos@gmail.com' }
  s.source           = { :git => 'https://github.com/carlosmouracorreia/RangeRadiusMKMapView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/correiask8'

  s.ios.deployment_target = '9.0'
  s.swift_version = '4.0'

  s.source_files = 'RangeRadiusMKMapView/Classes/**/*'
  # s.resource_bundles = {
  #   'RangeRadiusMKMapView' => ['RangeRadiusMKMapView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
