platform :ios, '12.0'
inhibit_all_warnings!

target 'kongxia' do
  
  pod 'Pingpp'
  pod 'Pingpp/Alipay'
  
  #   高德地图
      pod 'AMap2DMap', '~> 5.6.1'
      pod 'AMapLocation', '~> 2.10.0'
      pod 'AMapSearch', '~> 7.1.0'
      pod 'AMapFoundation', '~> 1.8.2'
      
#   七牛
    pod 'Qiniu', '~> 8.2.0'
    
#   友盟
#    pod 'UMengAnalytics', '~> 4.2.4'
    
#   融云
    pod 'RongCloudIM/IMLib', '~> 5.2.4.1'
    pod 'RongCloudIM/IMKit', '~> 5.2.4.1'
    
#   智齿
    pod 'SobotKit', '~> 3.2.0'
    
#   七牛短视频
pod 'PLShortVideoKit', :podspec => 'https://raw.githubusercontent.com/pili-engineering/PLShortVideoKit/master/PLShortVideoKit-Smart.podspec'
    pod 'PLPlayerKit', '~> 3.4.7'
    
#   美颜
    pod 'AgoraRtcEngine_iOS' , '~> 3.6.1.1'
    pod 'GPUImage', '~> 0.1.7'
    
    pod 'libOpenInstallSDK', '~> 2.8.0'
    pod 'SDWebImage', '~> 4.4.6'
    pod 'AFNetworking', '~> 3.2.1'
    pod 'JSONModel', '~> 1.8.0'
    pod 'UITableView+FDTemplateLayoutCell', '~> 1.6'
    pod 'Underscore.m', '~> 0.3.0'
    pod 'NMRangeSlider', '~> 1.2.1'
    pod 'XHLaunchAd', '~> 3.9.12'
    pod 'SKTagView', '~> 0.9.2'
    pod 'MGSwipeTableCell', '~> 1.6.11'
    pod 'MJRefresh', '~> 3.2.3'
    pod 'SVProgressHUD', '~> 2.2.5'
    pod 'Masonry', '~> 1.1.0'
    pod 'YTKKeyValueStore', '~> 0.1.2'
    pod 'TMCache', '~> 2.1.0'
    pod 'RegexKitLite-NoWarning', '~> 1.1.0'
    pod 'YYModel', '~> 1.0.4'
    pod 'LCActionSheet', '~> 3.3.3'
    pod 'FLAnimatedImage', '~> 1.0'
    pod 'IQKeyboardManager', '~> 6.5.6'
    pod 'YBImageBrowser', '~> 2.1.5'
    pod 'Bugly', '~> 2.5.93'
    pod 'SSZipArchive', '~> 2.2.2'
    pod 'YYImage', :git => 'https://github.com/QiuYeHong90/YYImage.git'
    
#    lottie
    pod 'lottie-ios', '~> 2.5.3'
    
#   Swift
    pod 'ObjectMapper', '~> 4.2.0'
    
#    post_install do |installer|
#
#      bitcode_strip_path = `xcrun --find bitcode_strip`.chop!
#      def strip_bitcode_from_framework(bitcode_strip_path, framework_relative_path)
#        framework_path = File.join(Dir.pwd, framework_relative_path)
#        command = "#{bitcode_strip_path} #{framework_path} -r -o #{framework_path}"
#        puts "Stripping bitcode: #{command}"
#        system(command)
#      end
#
#      framework_paths = [
#        "Pods/LibraryA/LibraryA/dynamic/LibraryA.xcframework/ios-arm64_armv7/LibraryA.framework/LibraryA",
#        "Pods/LibraryB/LibraryB.xcframework/ios-arm64_armv7/LibraryB.framework/LibraryB"
#      ]
#
#      framework_paths.each do |framework_relative_path|
#        strip_bitcode_from_framework(bitcode_strip_path, framework_relative_path)
#      end
#    end
end

# workaround
# https://stackoverflow.com/questions/79018593/asset-validation-failed-invalid-executable-the-executable-myapp-app-frameworks

#xcrun bitcode_strip -r Pods/AgoraRtcEngine_iOS/AgoraAIDenoiseExtension.xcframework/ios-arm64_armv7/AgoraAIDenoiseExtension.framework/AgoraAIDenoiseExtension -o Pods/AgoraRtcEngine_iOS/AgoraAIDenoiseExtension.xcframework/ios-arm64_armv7/AgoraAIDenoiseExtension.framework/AgoraAIDenoiseExtension

#xcrun bitcode_strip -r Pods/AgoraRtcEngine_iOS/AgoraCIExtension.xcframework/ios-arm64_armv7/AgoraCIExtension.framework/AgoraCIExtension -o Pods/AgoraRtcEngine_iOS/AgoraCIExtension.xcframework/ios-arm64_armv7/AgoraCIExtension.framework/AgoraCIExtension

#xcrun bitcode_strip -r Pods/AgoraRtcEngine_iOS/AgoraCore.xcframework/ios-arm64_armv7/AgoraCore.framework/AgoraCore -o Pods/AgoraRtcEngine_iOS/AgoraCore.xcframework/ios-arm64_armv7/AgoraCore.framework/AgoraCore

#xcrun bitcode_strip -r Pods/AgoraRtcEngine_iOS/AgoraDav1dExtension.xcframework/ios-arm64_armv7/AgoraDav1dExtension.framework/AgoraDav1dExtension -o Pods/AgoraRtcEngine_iOS/AgoraDav1dExtension.xcframework/ios-arm64_armv7/AgoraDav1dExtension.framework/AgoraDav1dExtension

#xcrun bitcode_strip -r Pods/AgoraRtcEngine_iOS/AgoraFDExtension.xcframework/ios-arm64_armv7/AgoraFDExtension.framework/AgoraFDExtension -o Pods/AgoraRtcEngine_iOS/AgoraFDExtension.xcframework/ios-arm64_armv7/AgoraFDExtension.framework/AgoraFDExtension

#xcrun bitcode_strip -r Pods/AgoraRtcEngine_iOS/AgoraJNDExtension.xcframework/ios-arm64_armv7/AgoraJNDExtension.framework/AgoraJNDExtension -o Pods/AgoraRtcEngine_iOS/AgoraJNDExtension.xcframework/ios-arm64_armv7/AgoraJNDExtension.framework/AgoraJNDExtension

#xcrun bitcode_strip -r Pods/AgoraRtcEngine_iOS/AgoraMediaPlayerPlugin.xcframework/ios-arm64_armv7/AgoraMediaPlayerPlugin.framework/AgoraMediaPlayerPlugin -o Pods/AgoraRtcEngine_iOS/AgoraMediaPlayerPlugin.xcframework/ios-arm64_armv7/AgoraMediaPlayerPlugin.framework/AgoraMediaPlayerPlugin

#xcrun bitcode_strip -r Pods/AgoraRtcEngine_iOS/AgoraRtcKit.xcframework/ios-arm64_armv7/AgoraRtcKit.framework/AgoraRtcKit -o Pods/AgoraRtcEngine_iOS/AgoraRtcKit.xcframework/ios-arm64_armv7/AgoraRtcKit.framework/AgoraRtcKit

#xcrun bitcode_strip -r Pods/AgoraRtcEngine_iOS/AgoraSoundTouch.xcframework/ios-arm64_armv7/AgoraSoundTouch.framework/AgoraSoundTouch -o Pods/AgoraRtcEngine_iOS/AgoraSoundTouch.xcframework/ios-arm64_armv7/AgoraSoundTouch.framework/AgoraSoundTouch

#xcrun bitcode_strip -r Pods/AgoraRtcEngine_iOS/AgoraSuperResolutionExtension.xcframework/ios-arm64_armv7/AgoraSuperResolutionExtension.framework/AgoraSuperResolutionExtension -o Pods/AgoraRtcEngine_iOS/AgoraSuperResolutionExtension.xcframework/ios-arm64_armv7/AgoraSuperResolutionExtension.framework/AgoraSuperResolutionExtension

#xcrun bitcode_strip -r Pods/AgoraRtcEngine_iOS/AgoraVideoProcessExtension.xcframework/ios-arm64_armv7/AgoraVideoProcessExtension.framework/AgoraVideoProcessExtension -o Pods/AgoraRtcEngine_iOS/AgoraVideoProcessExtension.xcframework/ios-arm64_armv7/AgoraVideoProcessExtension.framework/AgoraVideoProcessExtension

#xcrun bitcode_strip -r Pods/AgoraRtcEngine_iOS/AgoraVideoSegmentationExtension.xcframework/ios-arm64_armv7/AgoraVideoSegmentationExtension.framework/AgoraVideoSegmentationExtension -o Pods/AgoraRtcEngine_iOS/AgoraVideoSegmentationExtension.xcframework/ios-arm64_armv7/AgoraVideoSegmentationExtension.framework/AgoraVideoSegmentationExtension

#xcrun bitcode_strip -r Pods/AgoraRtcEngine_iOS/Agorafdkaac.xcframework/ios-arm64_armv7/Agorafdkaac.framework/Agorafdkaac -o Pods/AgoraRtcEngine_iOS/Agorafdkaac.xcframework/ios-arm64_armv7/Agorafdkaac.framework/Agorafdkaac

#xcrun bitcode_strip -r Pods/AgoraRtcEngine_iOS/Agoraffmpeg.xcframework/ios-arm64_armv7/Agoraffmpeg.framework/Agoraffmpeg -o Pods/AgoraRtcEngine_iOS/Agoraffmpeg.xcframework/ios-arm64_armv7/Agoraffmpeg.framework/Agoraffmpeg

#xcrun bitcode_strip -r Pods/PLPlayerKit/Pod/Library/PLPlayerKit.framework/PLPlayerKit -o Pods/PLPlayerKit/Pod/Library/PLPlayerKit.framework/PLPlayerKit

#xcrun bitcode_strip -r Pods/PLPlayerKit/Pod/Library/PLPlayerKit.framework/PLPlayerKit -o Pods/PLPlayerKit/Pod/Library/PLPlayerKit.framework/PLPlayerKit

#xcrun bitcode_strip -r Pods/RongCloudIM/RongCloudIM/RongChatRoom.xcframework/ios-arm64_armv7/RongChatRoom.framework/RongChatRoom -o Pods/RongCloudIM/RongCloudIM/RongChatRoom.xcframework/ios-arm64_armv7/RongChatRoom.framework/RongChatRoom

#xcrun bitcode_strip -r Pods/RongCloudIM/RongCloudIM/RongCustomerService.xcframework/ios-arm64_armv7/RongCustomerService.framework/RongCustomerService -o Pods/RongCloudIM/RongCloudIM/RongCustomerService.xcframework/ios-arm64_armv7/RongCustomerService.framework/RongCustomerService

#xcrun bitcode_strip -r Pods/RongCloudIM/RongCloudIM/RongDiscussion.xcframework/ios-arm64_armv7/RongDiscussion.framework/RongDiscussion -o Pods/RongCloudIM/RongCloudIM/RongDiscussion.xcframework/ios-arm64_armv7/RongDiscussion.framework/RongDiscussion

#xcrun bitcode_strip -r Pods/RongCloudIM/RongCloudIM/RongIMKit.xcframework/ios-arm64_armv7/RongIMKit.framework/RongIMKit -o Pods/RongCloudIM/RongCloudIM/RongIMKit.xcframework/ios-arm64_armv7/RongIMKit.framework/RongIMKit

#xcrun bitcode_strip -r Pods/RongCloudIM/RongCloudIM/RongIMLib.xcframework/ios-arm64_armv7/RongIMLib.framework/RongIMLib -o Pods/RongCloudIM/RongCloudIM/RongIMLib.xcframework/ios-arm64_armv7/RongIMLib.framework/RongIMLib

#xcrun bitcode_strip -r Pods/RongCloudIM/RongCloudIM/RongIMLibCore.xcframework/ios-arm64_armv7/RongIMLibCore.framework/RongIMLibCore -o Pods/RongCloudIM/RongCloudIM/RongIMLibCore.xcframework/ios-arm64_armv7/RongIMLibCore.framework/RongIMLibCore

#xcrun bitcode_strip -r Pods/RongCloudIM/RongCloudIM/RongLocation.xcframework/ios-arm64_armv7/RongLocation.framework/RongLocation -o Pods/RongCloudIM/RongCloudIM/RongLocation.xcframework/ios-arm64_armv7/RongLocation.framework/RongLocation

#xcrun bitcode_strip -r Pods/RongCloudIM/RongCloudIM/RongPublicService.xcframework/ios-arm64_armv7/RongPublicService.framework/RongPublicService -o Pods/RongCloudIM/RongCloudIM/RongPublicService.xcframework/ios-arm64_armv7/RongPublicService.framework/RongPublicService
