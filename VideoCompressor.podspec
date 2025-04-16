Pod::Spec.new do |s|
  s.name         = 'VideoCompressor'
  s.version      = '1.0.0'  # 👈 必须和你 Git 的 tag 一致
  s.summary      = 'A Swift video compression wrapper using NextLevelSessionExporter.'
  s.description  = <<-DESC
    VideoCompressor is a simple iOS SDK that wraps video compression functionality using NextLevelSessionExporter.
  DESC
  s.homepage     = 'https://github.com/QiSDK/iOS_VideoCompressSDK'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'YourName' => 'your@email.com' }

  s.source       = { 
    :git => 'https://github.com/QiSDK/iOS_VideoCompressSDK.git', 
    :tag => s.version.to_s 
  }

  s.platform     = :ios, '11.0'
  s.swift_version = '5.0'

  s.source_files  = 'VideoCompressor/Sources/VideoCompressor/**/*.{swift}'  # 👈 路径需与仓库实际一致
  s.module_name   = 'VideoCompressor'

  s.dependency 'NextLevelSessionExporter'
end
