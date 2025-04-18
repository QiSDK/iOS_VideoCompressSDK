import Foundation
import AVFoundation
import NextLevelSessionExporter

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
        let exporter = NextLevelSessionExporter(withAsset: asset)

        // 输出为 mp4 + H.264 编码
        exporter.outputFileType = .mp4
        exporter.outputURL = outputURL

        // 视频压缩参数
        exporter.videoOutputConfiguration = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: configuration.width,
            AVVideoHeightKey: configuration.height,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: configuration.bitrate,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel
            ]
        ]

        // 音频压缩参数
        exporter.audioOutputConfiguration = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey: configuration.audioChannels,
            AVSampleRateKey: configuration.audioSampleRate,
            AVEncoderBitRateKey: configuration.audioBitrate
        ]

        // 可选：导出进度回调
        exporter.export { progress in
            // 根据进度回调进行处理
            // 进度回调，可以用于更新 UI 等操作
        }
        // 开始导出
        exporter.export { status in
            switch status {
            case .success:
                completion(true, nil)
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
}
