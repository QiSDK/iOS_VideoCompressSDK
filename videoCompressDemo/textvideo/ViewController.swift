import UIKit
import AVKit
import PhotosUI
import VideoCompressor
import SVProgressHUD

class ViewController: UIViewController, PHPickerViewControllerDelegate {
    
    var originalVideoURL: URL?
    var compressedVideoURL: URL?
    var originalImage: UIImage?
    let imageView = UIImageView()
    
    let selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("选择视频", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(selectVideo), for: .touchUpInside)
        return button
    }()
    
    let compressButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("压缩视频", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(compressVideo), for: .touchUpInside)
        return button
    }()
    
    let selectIMGButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("选择图片", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(selectIMG), for: .touchUpInside)
        return button
    }()
    
    let compressIMGButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("压缩图片", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(compressIMG), for: .touchUpInside)
        return button
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // imageView 设置
//        imageView.contentMode = .scaleAspectFit
//        imageView.layer.borderColor = UIColor.lightGray.cgColor
//        imageView.layer.borderWidth = 1
//        imageView.clipsToBounds = true
        
        let stack = UIStackView(arrangedSubviews: [selectIMGButton,compressIMGButton,selectButton, compressButton, infoLabel])
        stack.axis = .vertical
        stack.spacing = 50
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    @objc func selectVideo() {
        SVProgressHUD.show(withStatus: "请稍后...")
        var config = PHPickerConfiguration()
        config.filter = .videos
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func selectIMG() {
        SVProgressHUD.show(withStatus: "请稍后...")
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        SVProgressHUD.dismiss()
        guard let itemProvider = results.first?.itemProvider else { return }
        if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
                guard let self = self, let image = object as? UIImage else { return }
                DispatchQueue.main.async {
                    self.originalImage = image
                    self.imageView.image = image
                    if let data = image.jpegData(compressionQuality: 1.0) {
                        let sizeKB = data.count / 1024
                        self.infoLabel.text = "原始大小：\(sizeKB) KB"
                        self.compressButton.isHidden = false
                    }
                }
            }
        }else if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier){
            guard let item = results.first?.itemProvider,
                  item.hasItemConformingToTypeIdentifier("public.movie") else { return }
            
            item.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, error in
                guard let url = url else { return }
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                try? FileManager.default.copyItem(at: url, to: tempURL)
                self.originalVideoURL = tempURL
                DispatchQueue.main.async {
                    self.infoLabel.text = "已选择视频：\(self.fileSize(for: tempURL))"
                    self.playVideo(url: tempURL)
                }
            }
        }
    }
    
    @objc func compressIMG() {
        guard let original = originalImage else { return }
        
        if let compressedData = VideoCompressor.compressImage(original, targetSize: CGSize(width: 800, height: 800), quality: 0.5) {
            let sizeKB = compressedData.count / 1024
            self.infoLabel.text! += "\n压缩后大小：\(sizeKB) KB"
            
            // 可选：显示压缩图
            self.imageView.image = UIImage(data: compressedData)
            
            // 可选：保存到 Documents
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("compressed.jpg")
            try? compressedData.write(to: url)
            print("已保存到：\(url)")
        }
    }
    
    @objc func compressVideo() {
        guard let inputURL = originalVideoURL else { return }
        
        //        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("compressed.mp4")
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputURL = documentsDirectory.appendingPathComponent("compressed.mp4")
        
        if FileManager.default.fileExists(atPath: inputURL.path) {
            print("Input file exists.")
        } else {
            print("Input file does not exist.")
        }
        let outputDirectory = outputURL.deletingLastPathComponent()
        if FileManager.default.isWritableFile(atPath: outputDirectory.path) {
            print("Output directory is writable.")
        } else {
            print("Output directory is not writable.")
        }
        
        let config = VideoCompressor.Configuration()
        
        // 显示加载中
        SVProgressHUD.show(withStatus: "压缩中...")
        
        VideoCompressor.compressVideo(inputURL: inputURL, outputURL: outputURL, configuration: config) { success, error in
            DispatchQueue.main.async {
                if success {
                    SVProgressHUD.showSuccess(withStatus: "压缩成功")
                    self.compressedVideoURL = outputURL
                    let originalSize = self.fileSize(for: inputURL)
                    let compressedSize = self.fileSize(for: outputURL)
                    self.infoLabel.text = "压缩成功\n\n\n原大小: \(originalSize)\n\n\n压缩后: \(compressedSize)"
                    self.playVideo(url: outputURL)
                } else {
                    SVProgressHUD.showError(withStatus: "压缩失败")
                    self.infoLabel.text = "压缩失败: \(error ?? "未知错误")"
                }
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        present(playerVC, animated: true) {
            player.play()
        }
    }
    
    func fileSize(for url: URL) -> String {
        guard let fileSize = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int else {
            return "Unknown"
        }
        let sizeInMB = Double(fileSize) / (1024 * 1024)
        return String(format: "%.2f MB", sizeInMB)
    }
}

