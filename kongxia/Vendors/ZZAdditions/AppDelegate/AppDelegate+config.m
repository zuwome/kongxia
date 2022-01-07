//
//  AppDelegate+config.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "AppDelegate+config.h"

#import <IQKeyboardManager.h>

#import <UMSocialCore/UMSocialCore.h>

#import <AlipaySDK/AlipaySDK.h>

#import "Pingpp.h"

#import <RongIMKit/RongIMKit.h>

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "MiPushSDK.h"

#import <IDLFaceSDK/IDLFaceSDK.h>
#import "FaceParameterConfig.h"

#import "MSDPreventImagePickerCrashOn3DTouch.h"

#import "ZZMessageChatWechatPayModel.h"
#import "ZZGifMessageModel.h"
#import "ZZChatPacketModel.h"
#import "ZZChatOrderInfoModel.h"
#import "ZZChatReportModel.h"
#import "ZZChatOrderNotifyModel.h"
#import "ZZChatConnectModel.h"
#import "ZZChatSelectionModel.h"
#import "ZZChatCancelModel.h"
#import "ZZVideoMessage.h"//私聊挂断
#import "ZZBanStateModel.h"//用户被封禁
#import "ZZChatTaskFreeModel.h"
#import "ZZChatGiftModel.h"

@implementation AppDelegate (config)

- (void)basicConfig {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    // scrollView滚动
    [self configScrollViewInIos11];
    
    [self configSVProgressHUD];
    
    [self configSDWebImage];
    
    // 6S在调用相册的时候 3Dtouch会崩溃所以要预防
    MSDPreventImagePickerCrashOn3DTouch();
}

/*
  scrollView滚动
 */
- (void)configScrollViewInIos11 {
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView alloc].estimatedSectionFooterHeight = 0;
        [UICollectionView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UIWebView appearance].scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [WKWebView appearance].scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)configSVProgressHUD {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithHexValue:0xf3f5f7 andAlpha:1]];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
}

- (void)configSDWebImage {
    // 加载的头像 不进行解压
    SDImageCache *canche = [SDImageCache sharedImageCache];
    canche.config.shouldDecompressImages = NO;

    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    downloder.shouldDecompressImages = NO;
}

#pragma mark - ThirdParty
- (void)configureThirdParty {

    // IQKeyboard
    [self configKeyboard];
    
    // 百度
    [self configBaiduFaceCheck];
    
    // 友盟
    [self configUM];
    
    // 融云
    [self configRCIM];
        
    // 高德
    [self configAMap];
}

/*
 IQKeyboard
 */
- (void)configKeyboard {
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

/*
 百度人脸配置
*/
- (void)configBaiduFaceCheck {
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
    [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
}

/*
 高德配置
*/
- (void)configAMap {
    // 高德
    [AMapServices sharedServices].apiKey = @"ddbc9ec789eb08c4f18c4232e7732446";
}

/*
 友盟配置
*/
- (void)configUM {
    // UMeng 社会化分享
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_KEY];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:WEIXIN_ID
                                       appSecret:WEIXIN_SECRET
                                     redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                          appKey:QQ_ID
                                       appSecret:QQ_KEY
                                     redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina
                                          appKey:WEIBO_KEY
                                       appSecret:WEIBO_SECRET
                                     redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //友盟统计、自定义事件
    UMConfigInstance.appKey = UMENG_KEY;
    [MobClick startWithConfigure:UMConfigInstance];
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#else
    [MobClick setLogEnabled:NO];
#endif
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
}

/*
 融云配置
 */
- (void)configRCIM {
    //融云
    [[RCIM sharedRCIM] initWithAppKey:[kBase_URL containsString:@"zuwome.com"] ? RONGCLOUD_IM_APPKEY : RONGCLOUD_IM_TEST_APPKEY];
    [[RCIM sharedRCIM] registerMessageType:[ZZChatPacketModel class]];
    [[RCIM sharedRCIM] registerMessageType:[ZZChatOrderInfoModel class]];
    [[RCIM sharedRCIM] registerMessageType:[ZZChatTaskFreeModel class]];
    [[RCIM sharedRCIM] registerMessageType:[ZZChatReportModel class]];
    [[RCIM sharedRCIM] registerMessageType:[ZZChatCancelModel class]];
    [[RCIM sharedRCIM] registerMessageType:[ZZChatOrderNotifyModel class]];
    [[RCIM sharedRCIM] registerMessageType:[ZZChatConnectModel class]];
    [[RCIM sharedRCIM] registerMessageType:[ZZChatSelectionModel class]];
    [[RCIM sharedRCIM] registerMessageType:[ZZVideoMessage class]];//拨打电话的model
    [[RCIM sharedRCIM] registerMessageType:[ZZBanStateModel class]];
    [[RCIM sharedRCIM] registerMessageType:[ZZMessageChatWechatPayModel class]];//拨打电话的model
    [[RCIM sharedRCIM] registerMessageType:[ZZGifMessageModel class]];//gif 图
    [[RCIM sharedRCIM] registerMessageType:[ZZChatGiftModel class]]; // 礼物
}

@end
