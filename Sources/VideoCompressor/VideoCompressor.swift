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
        completion: @escaping (Bool, String?) -> Void
    ) {
        let asset = AVAsset(url: inputURL)
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

        exporter.export { status in
            switch status {
            case .completed:
                completion(true, nil)
            case .failed:
                completion(false, exporter.error?.localizedDescription ?? "Unknown error")
            case .cancelled:
                completion(false, "Export cancelled")
            @unknown default:
                completion(false, "Unknown status")
            }
        }
    }
}