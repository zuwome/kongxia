//
//  ZZAppDelegateConfig.m
//  zuwome
//
//  Created by angBiu on 2016/11/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZAppDelegateConfig.h"
#import "ZZMessageChatWechatPayModel.h"
#import "ZZGifMessageModel.h"

#import <UMSocialCore/UMSocialCore.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "Pingpp.h"
#import <RongIMKit/RongIMKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <SobotKit/SobotKit.h>
#import "MiPushSDK.h"
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
#import "ZZChatKTVModel.h"
#import "ZZVideoInviteModel.h"
#import "WXApi.h"

@implementation ZZAppDelegateConfig

+ (void)config
{
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString * _Nonnull log) {
        NSLog(@"#####:%@", log);
    }];
    [WXApi registerApp:WEIXIN_ID universalLink:@"https://active.zuwome.com/app/"];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    // 高德
    [AMapServices sharedServices].apiKey = @"ddbc9ec789eb08c4f18c4232e7732446";
    
    // UMeng 社会化分享
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_KEY];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WEIXIN_ID appSecret:WEIXIN_SECRET redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_ID  appSecret:QQ_KEY redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:WEIBO_KEY  appSecret:WEIBO_SECRET redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
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
    [[RCIM sharedRCIM] registerMessageType:[ZZChatKTVModel class]]; // 点唱
    [[RCIM sharedRCIM] registerMessageType:[ZZVideoInviteModel class]];
    
    // 智齿
    [ZCSobotApi initSobotSDK:@"bb85bc043cde4887be270e6d7792e572" host:@"https://api.sobot.com" result:^(id  _Nonnull object) {
        NSLog(@"AASSA");
    }];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithHexValue:0xf3f5f7 andAlpha:1]];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
}

@end
