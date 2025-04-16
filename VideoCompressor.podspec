Pod::Spec.new do |s|
  s.name         = 'VideoCompressor'
  s.version      = '1.0.0'
  s.summary      = 'A Swift video compression wrapper using NextLevelSessionExporter.'
  s.description  = 'VideoCompressor is a simple wrapper SDK for video compression on iOS.'
  s.homepage     = 'https://github.com/QiSDK/iOS_VideoCompressSDK'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'YourName' => 'your@email.com' }
  s.source       = { :git => 'https://github.com/QiSDK/iOS_VideoCompressSDK.git', :tag => s.version.to_s }

  s.platform     = :ios, '11.0'
  s.swift_version = '5.0'

  s.source_files  = 'Sources/VideoCompressor/**/*.{swift}'
  s.dependency 'NextLevelSessionExporter'
end