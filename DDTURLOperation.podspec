#
# Be sure to run `pod lib lint DDTURLOperation.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DDTURLOperation"
  s.version          = "0.3.0"
  s.summary          = "A collection of useful network based, NSOperations."
  s.description      = <<-DESC
						The following Operations are provided
						
						DDTURLDownloadOperation
						DDTURLUploadOperation
						DDTURLDataOperation
                       DESC
  s.homepage         = "https://github.com/TheAppCoach/DDTURLOperation"
  s.license          = 'MIT'
  s.author           = { "mcBontempi" => "mcbontempi@gmail.com" }
  s.source           = { :git => "https://github.com/TheAppCoach/DDTURLOperation.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'DDTURLOperation' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
