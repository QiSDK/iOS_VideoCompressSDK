Pod::Spec.new do |s|
  s.name             = 'VideoCompressor'  # 这里是你的库的名称
  s.version          = '1.0.0'  # 库的版本号
  s.summary          = 'A simple video compression SDK'
  s.description      = 'A Swift SDK to compress videos using NextLevelSessionExporter.'
  s.homepage         = 'https://github.com/QiSDK/iOS_VideoCompressSDK.git'  # 你的 GitHub 仓库链接
  s.license          = { :type => 'MIT', :file => 'LICENSE' }  # 选择一个合适的开源协议
  s.author           = { 'subifu' => 'subifu908@gmail.com' }  # 你的姓名和邮箱
  s.source           = { :git => 'https://github.com/QiSDK/iOS_VideoCompressSDK.git', :tag => s.version.to_s }  # 仓库的地址，tag 是版本号
  s.platform         = :ios, '12.0'  # 最低支持 iOS 12.0

  s.source_files     = 'VideoCompressor/Sources/**/*.swift'  # 源码文件路径
  s.public_header_files = 'VideoCompressor/Sources/**/*.h'  # 如果有公共头文件
  s.frameworks        = 'AVFoundation', 'NextLevelSessionExporter'  # 需要的框架
  s.dependency 'NextLevelSessionExporter'  # 如果依赖了其他的库
end
