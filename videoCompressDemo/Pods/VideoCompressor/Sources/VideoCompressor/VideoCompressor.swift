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
}
