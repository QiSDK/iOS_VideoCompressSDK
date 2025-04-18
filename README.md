# VideoCompressor

A lightweight video compression SDK based on `NextLevelSessionExporter`, allowing for configurable and efficient video compression.

## Installation

### CocoaPods

```ruby
pod 'VideoCompressor', :git => 'https://github.com/QiSDK/iOS_VideoCompressSDK.git', :tag => '1.0.4'
```

## Usage

```swift
let inputURL = ...
let outputURL = ...
let config = VideoCompressor.Configuration(width: 720, height: 1280)
VideoCompressor.compressVideo(inputURL: inputURL, outputURL: outputURL, configuration: config) { success, error in
    if success {
        print("Compression succeeded!")
    } else {
        print("Compression failed: \(error ?? "Unknown error")")
    }
}
```
