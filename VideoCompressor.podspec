Pod::Spec.new do |s|
  s.name         = "VideoCompressor"
  s.version      = "1.0.4"
  s.summary      = "A lightweight video compression library using NextLevelSessionExporter."
  s.description  = "VideoCompressor is a Swift SDK that wraps NextLevelSessionExporter to provide flexible video compression capabilities."
  s.homepage     = "https://github.com/QiSDK/iOS_VideoCompressSDK"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Qi" => "qi@example.com" }
  s.platform     = :ios, "12.0"
  s.swift_versions = ["5.0"]
  s.source       = { :git => "https://github.com/QiSDK/iOS_VideoCompressSDK.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/**/*.swift"
  s.dependency "NextLevelSessionExporter"
end