import Foundation
import AVFoundation
import NextLevelSessionExporter

public class VideoCompressor {
    
    public static func compressVideo(inputURL: URL, outputURL: URL, completion: @escaping (Bool, String?) -> Void) {
        // 创建 AVAsset 对象
        let asset = AVAsset(url: inputURL)
        
        // 创建 NextLevelSessionExporter 实例
        let exporter = NextLevelSessionExporter(withAsset: asset)
        
        // 设置输出 URL 和文件类型
        exporter.outputURL = outputURL
        exporter.outputFileType = .mp4
        
        // 配置视频输出设置
        exporter.videoOutputConfiguration = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: 720,  // 压缩后的分辨率宽度
            AVVideoHeightKey: 1280 // 压缩后的分辨率高度
        ]
        
        // 配置音频输出设置
        exporter.audioOutputConfiguration = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,  // 音频编码格式
            AVNumberOfChannelsKey: 2,            // 音频声道数
            AVSampleRateKey: 44100,              // 音频采样率
            AVEncoderBitRateKey: 128000          // 音频比特率
        ]
        
        // 开始视频导出
        exporter.export { status in
            switch status {
            case .completed:
                // 如果导出成功，返回成功的回调
                completion(true, nil)
            case .failed:
                // 如果导出失败，返回失败的回调
                let errorMessage = exporter.error?.localizedDescription ?? "Unknown error"
                completion(false, errorMessage)
            case .cancelled:
                // 如果导出被取消，返回取消的回调
                completion(false, "Export was cancelled.")
            @unknown default:
                completion(false, "Unknown status.")
            }
        }
    }
}
