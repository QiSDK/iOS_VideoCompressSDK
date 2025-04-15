//
//  Untitled.swift
//  videoCompressIOS
//
//  Created by white on 14/04/2025.
//

import Foundation
import AVFoundation
import NextLevelSessionExporter

public class VideoCompressor {

    public static let shared = VideoCompressor()
    private init() {}

    /// 压缩视频方法
    /// - Parameters:
    ///   - inputURL: 输入视频文件路径
    ///   - outputURL: 输出压缩后的视频路径
    ///   - width: 压缩视频宽度（默认720）
    ///   - height: 压缩视频高度（默认1280）
    ///   - bitrate: 视频码率（默认2Mbps）
    ///   - progressHandler: 进度回调（0~1）
    ///   - completion: 完成回调，返回结果 URL 或错误
    public func compressVideo(
        inputURL: URL,
        outputURL: URL,
        width: Int = 720,
        height: Int = 1280,
        bitrate: Int = 2_000_000,
        progressHandler: ((Float) -> Void)? = nil,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        let asset = AVAsset(url: inputURL)
        let exporter = NextLevelSessionExporter(withAsset: asset)

        exporter.outputURL = outputURL
        exporter.outputFileType = .mp4
        exporter.optimizeForNetworkUse = true

        exporter.videoOutputConfiguration = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: bitrate,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel
            ]
        ]

        exporter.audioOutputConfiguration = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100,
            AVEncoderBitRateKey: 128000
        ]

        exporter.export(progressHandler: { progress in
            progressHandler?(progress)
        }, completionHandler: { status in
            switch status {
            case .completed:
                completion(.success(outputURL))
            case .failed, .cancelled:
                completion(.failure(exporter.error ?? NSError(domain: "VideoCompression", code: -1, userInfo: nil)))
            default:
                break
            }
        })
    }
}
