import Foundation
import NextLevelSessionExporter
import AVFoundation

public class VideoCompressor {
    public static func compressVideo(inputURL: URL, outputURL: URL, completion: @escaping (Bool) -> Void) {
        let exporter = NextLevelSessionExporter(withAsset: AVAsset(url: inputURL))
        exporter.outputURL = outputURL
        exporter.outputFileType = AVFileType.mp4
        exporter.videoOutputConfiguration = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: 720,
            AVVideoHeightKey: 1280
        ]
        exporter.audioOutputConfiguration = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100,
            AVEncoderBitRateKey: 128000
        ]
        exporter.export { status in
            switch status {
            case .completed:
                completion(true)
            default:
                completion(false)
            }
        }
    }
}