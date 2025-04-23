import Foundation
import AVFoundation
import NextLevelSessionExporter
import UIKit

public class VideoCompressor {
    
    public struct Configuration {
        public var width: Int = 720
        public var height: Int = 1280
        public var bitrate: Int = 2_000_000
        public var audioBitrate: Int = 128_000
        public var audioSampleRate: Int = 44_100
        public var audioChannels: Int = 2
        
        public init() {}
    }
    
    public static func compressVideo(
        inputURL: URL,
        outputURL: URL,
        configuration: Configuration = Configuration(),
        progressHandler: ((Float) -> Void)? = nil,
        completion: @escaping (Bool, String?) -> Void
    ) {
        let asset = AVAsset(url: inputURL)
        asset.loadValuesAsynchronously(forKeys: ["tracks"]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "tracks", error: &error)
            if status == .loaded {
                let exporter = NextLevelSessionExporter(withAsset: asset)
                exporter.outputURL = outputURL
                exporter.outputFileType = .mp4
                exporter.videoOutputConfiguration = [
                    AVVideoCodecKey: AVVideoCodecType.h264,
                    AVVideoWidthKey: configuration.width,
                    AVVideoHeightKey: configuration.height,
                    AVVideoCompressionPropertiesKey: [
                        AVVideoAverageBitRateKey: configuration.bitrate,
                        AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel
                    ]
                ]
                exporter.audioOutputConfiguration = [
                    AVFormatIDKey: kAudioFormatMPEG4AAC,
                    AVNumberOfChannelsKey: configuration.audioChannels,
                    AVSampleRateKey: configuration.audioSampleRate,
                    AVEncoderBitRateKey: configuration.audioBitrate
                ]
                if FileManager.default.fileExists(atPath: outputURL.path) {
                    try? FileManager.default.removeItem(at: outputURL)
                }
                exporter.export(
                    progressHandler: { progress in
                        print("进度: \(progress)")
                    },
                    completionHandler: { status in
                        switch status {
                        case .success:
                            completion(true, nil)
                        case .failure(let error):
                            completion(false, error.localizedDescription)
                        }
                    }
                )
                
            } else {
                print("Failed to load asset tracks: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    /// 压缩图片
    /// - Parameters:
    ///   - image: 原始 UIImage
    ///   - targetSize: 目标尺寸（可选，不填表示不改变尺寸）
    ///   - quality: 压缩质量，0~1（1表示原图质量）
    /// - Returns: 压缩后的 JPEG Data
    public static func compressImage(_ image: UIImage,
                                     targetSize: CGSize? = nil,
                                     quality: CGFloat = 0.7) -> Data? {
        var resizedImage = image
        
        if let size = targetSize {
            resizedImage = resizeImage(image: image, targetSize: size)
        }
        
        return resizedImage.jpegData(compressionQuality: quality)
    }
    
    /// 调整图片大小
    private static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // 按较小比例缩放（等比缩放）
        let ratio = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
}
