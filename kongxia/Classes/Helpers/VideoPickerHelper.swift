import Foundation
import Photos
import UIKit


import Foundation
import Photos
import PhotosUI
import UIKit

@available(iOS 14, *)
@objc class VideoHelper: NSObject {

    /// 检查权限并获取视频的 PHAsset
    /// - Parameters:
    ///   - viewController: 当前的视图控制器，用于显示权限请求弹窗
    ///   - completion: 视频的 PHAsset 或错误回调
    @objc static func fetchVideoAsset(from viewController: UIViewController, completion: @escaping (PHAsset?, Error?) -> Void) {
        // 检查权限
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            presentPicker(in: viewController, completion: completion)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        presentPicker(in: viewController, completion: completion)
                    } else {
                        completion(nil, NSError(domain: "VideoHelper", code: 1, userInfo: [NSLocalizedDescriptionKey: "访问相册的权限被拒绝"]))
                    }
                }
            }
        default:
            completion(nil, NSError(domain: "VideoHelper", code: 1, userInfo: [NSLocalizedDescriptionKey: "访问相册的权限被拒绝"]))
        }
    }

    /// 使用 PHPickerViewController 展示视频选择器
    private static func presentPicker(in viewController: UIViewController, completion: @escaping (PHAsset?, Error?) -> Void) {
        // 配置 PHPicker
        if #available(iOS 14, *) {
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.filter = .videos // 仅显示视频
            config.selectionLimit = 1 // 只允许选择一个视频

            let picker = PHPickerViewController(configuration: config)
            picker.delegate = PickerDelegate.shared
            PickerDelegate.shared.completion = completion
            viewController.present(picker, animated: true, completion: nil)
        } else {
            completion(nil, NSError(domain: "VideoHelper", code: 2, userInfo: [NSLocalizedDescriptionKey: "当前系统版本不支持 PHPickerViewController"]))
        }
    }
}

/// Picker 代理单例
@available(iOS 14, *)
private class PickerDelegate: NSObject, PHPickerViewControllerDelegate {

    static let shared = PickerDelegate()
    var completion: ((PHAsset?, Error?) -> Void)?

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        guard let result = results.first else {
            completion?(nil, NSError(domain: "VideoHelper", code: 3, userInfo: [NSLocalizedDescriptionKey: "未选择任何视频"]))
            return
        }

        // 获取 PHAsset
        if let assetIdentifier = result.assetIdentifier {
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: nil)
            if let asset = fetchResult.firstObject {
                completion?(asset, nil)
            } else {
                completion?(nil, NSError(domain: "VideoHelper", code: 4, userInfo: [NSLocalizedDescriptionKey: "未找到视频的 PHAsset"]))
            }
        } else {
            completion?(nil, NSError(domain: "VideoHelper", code: 5, userInfo: [NSLocalizedDescriptionKey: "无法获取视频的标识符"]))
        }
    }
}
