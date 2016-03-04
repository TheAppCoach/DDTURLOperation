Pod::Spec.new do |s|
  s.name             = "DDTURLOperation"
  s.version          = "1.0.0"
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
end
