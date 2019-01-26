Pod::Spec.new do |s|

  s.name         = "MHCoreDataKit"
  s.version      = "1.0.0"
  s.source       = { :git => "https://github.com/KoCMoHaBTa/#{s.name}.git", :tag => "#{s.version}" }
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "Milen Halachev"
  s.summary      = "Using CoreData with convenience."
  s.homepage     = "https://github.com/KoCMoHaBTa/#{s.name}"

  s.description  = <<-DESC
                        A collection of useful tools that, which goal is to makes developer's life easier by reducing the complexity of using CoreData.
                    DESC

  s.swift_version = "4.2"
  s.ios.deployment_target = "8.0"

  s.source_files  = "#{s.name}/**/*.swift", "#{s.name}/**/*.{h,m}"
  s.public_header_files = "#{s.name}/**/*.h"

end
