	//
//  AppDelegate.m
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "APIKey.h"
#import "AppDelegate.h"
#import <UMSocialCore/UMSocialCore.h>
#import <AlipaySDK/AlipaySDK.h>
#import "Pingpp.h"
#import <RongIMKit/RongIMKit.h>
#import <Bugly/Bugly.h>
#import "WBReachabilityManager.h"
#import "Reachability.h"
#import "OpenInstallSDK.h"

#import "MSDPreventImagePickerCrashOn3DTouch.h"
#import "ZZTabBarViewController.h"
#import "ZZRentViewController.h"
#import "ZZChatViewController.h"
#import "ZZLinkWebViewController.h"
#import "ZZAgreementController.h"
#import "ZZTaskDetailViewController.h"
#import "ZZTasksViewController.h"
#import "ZZNewHomeViewController.h"
#import "ZZMyCommissionsController.h"
#import "ZZKTVPlazaController.h"
#import "ZZRentOrderPaymentViewController.h"
#import "ZZRentOrderPayCompleteViewController.h"

#import "ZZUrlSchemaModel.h"
#import "ZZNotificationHelper.h"
#import "ZZScrollToTopHelper.h"
#import "ZZUserDefaultsHelper.h"
#import "ZZAppDelegateConfig.h"
#import "ZZPushMessage.h"
#import "ZZLiveStreamHelper.h"
#import "ZZLocalPushManager.h"
#import "ZZPayHelper.h"

#import "ZZNewGuidView.h"
#import "WBKeyChain.h"
#import "ZZPayManager.h"
#import "ZZChatServerViewController.h"

#import "ZZShanChatNotificationHelper.h"

#import "JX_GCDTimerManager.h"
#import <RongIMKit/RongIMKit.h>
#import <IQKeyboardManager.h>

#import "ZZActivityUrlNetManager.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "FaceParameterConfig.h"
#import "MiPushSDK.h"

#import "ZZCommossionManager.h"
#import <XHLaunchAd.h>

@interface AppDelegate () <CLLocationManagerDelegate,ZZNewGuidViewDelegate, XHLaunchAdDelegate, MiPushSDKDelegate, UNUserNotificationCenterDelegate, OpenInstallDelegate>
{
    CLLocationManager *_LocationManager;
}

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;
@property (nonatomic, strong) NSDictionary *remoteInfo; // App被杀死收到远程推送的信息
@property (nonatomic, assign) BOOL haveLoad;
@property (nonatomic, assign) BOOL firstLoad;//是否是刚刚启动
@property (nonatomic, strong) ZZUrlSchemaModel *schemaModel;//urlschema打开
@property (nonatomic, assign) BOOL haveGetLocation;
@property (nonatomic, strong) ZZAgreementController *agreementController;
@property (nonatomic, strong) Reachability *reach;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    
    // Bugly
    [Bugly startWithAppId:BuglyID];
        
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.backgroundColor = [UIColor whiteColor];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
   
    [self monitorNetworkStatus];
    
    [LoginHelper setAliAuthenSDK];
    
    // 配置
    [self config:application];
    
    // scrollView滚动
    [self configScrollViewInIos11];
    
    // fetch 远程推送内信息
    _remoteInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  
    // 配置rootViewController
    [self loadGuidePage];
    
    // key
    [self uploadDeviceOnlyKey];
    
    // 内购
    [self InPurchasingStart];
    
    // 百度SDK
    [self configBaiduFaceCheck];
    
    // 通知
    [self addNotifications];
    
    // openInstall
    [self configureOpenInstall];
    
    [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
    NSDictionary *pushDic = [[RCIMClient sharedRCIMClient] getPushExtraFromLaunchOptions:launchOptions];
    if (pushDic) {
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id key in [pushDic allKeys]) {
            NSLog(@"%@", pushDic[key]);
        }
    }
    else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
    }
    
    // 6S在调用相册的时候 3Dtouch会崩溃所以要预防
    MSDPreventImagePickerCrashOn3DTouch();
    
    return YES;
}

- (void)monitorNetworkStatus {
    _reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [_reach startNotifier];
}

- (void)configBaiduFaceCheck {
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
    [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
}

- (void)reachabilityChanged:(NSNotification *)sender {
    NetworkStatus internetStatus = [self.reach currentReachabilityStatus];
    if (internetStatus) {
        // 可以访问网络
        NSLog(@"可以访问网络");
    }
    else {
        NSLog(@"没有可以访问的网络");
        // 没有可以访问的网络
    }
}

//启动内购,检测是否有漏单情况
- (void)InPurchasingStart {
    if ([ZZUserHelper shareInstance].isLogin) {
        [ZZPayHelper startManager];//内购
        [ZZActivityUrlNetManager requestHtmlActivityUrlDetailInfo];//h5活动页
    }
}

- (void)uploadDeviceOnlyKey {
    if ([ZZUserHelper shareInstance].isLogin) {
        NSString *uuid = [WBKeyChain keyChainLoadWithKey:DEVICE_ONLY_KEY];
        if (isNullString(uuid)) {
            uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
        [WBKeyChain keyChainSave:uuid key:DEVICE_ONLY_KEY];
        [[ZZUserHelper shareInstance].loginer updateWithParam:@{@"uuid" : uuid} next:nil];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([OpenInstallSDK handLinkURL:url]) {
        return YES;
    }
    
    WEAK_SELF();
    NSString *urlString = [url.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    [Pingpp handleOpenURL:url withCompletion:nil];
    if (result == NO) {
        NSRange range = [urlString rangeOfString:@"iOSZuwomeAppOpenApp://"];
        if (range.location != NSNotFound) {
            NSDictionary *aDict = [ZZUtils dictionaryWithJsonString:[urlString stringByReplacingOccurrencesOfString:@"iOSZuwomeAppOpenApp://" withString:@""]];
            _schemaModel = [[ZZUrlSchemaModel alloc] initWithDictionary:aDict error:nil];
            if (_haveLoad) {
                [weakSelf managerNextControllerWithModel:_schemaModel];
                _schemaModel = nil;
            }
        }
    }
    return result;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if (_haveLoad) {
        [self managerNotification:userInfo];
    }
    else {
        _remoteInfo = userInfo;
    }
}

// iOS 10 以下
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (_haveLoad) {
        [self managerNotification:userInfo];
    }
    else {
        _remoteInfo = userInfo;
    }
}

// iOS 10之后处于后台
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
     NSLog(@"PY_后台模式");
    NSDictionary *userInfo = response.notification.request.content.userInfo;

    if (_haveLoad) {
        [self managerNotification:userInfo];
    }
    else {
        _remoteInfo = userInfo;
    }
}

// 10 之后处于前台
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;

    if (_haveLoad) {
        [self managerNotification:userInfo];
    }
    else {
        _remoteInfo = userInfo;
    }
}

- (void)managerNotification:(NSDictionary *)userInfo {
    NSLog(@"PY_推送的消息详情%@",userInfo);
    NSDictionary *rcDict = [userInfo objectForKey:@"rc"];
    // 当远程推送数据存在 rc 时，所有携带的其他信息要在 userInfo[@"appData"][@"data"] 中获取
    NSString *typeStr = @"";
    NSDictionary *validDictionary = @{};
    
    if (rcDict) {
        validDictionary = [ZZUtils dictionaryWithJsonString:userInfo[@"appData"]];
        typeStr = validDictionary[@"data"][@"type"];
    }
    else {
        typeStr = userInfo[@"type"];
    }
    if ([typeStr integerValue] == 201)    {
        UITabBarController *tabs = (UITabBarController*)self.window.rootViewController;
        [ZZShanChatNotificationHelper localPushNotificationMessageDic:validDictionary[@"data"] tabbarViewController:tabs];
    }
    else if ([typeStr integerValue] == 28) {
        // 跳转到列表
        if ([[UIViewController currentDisplayViewController] isKindOfClass:[ZZTasksViewController class]]) {
            return;
        }
        ZZTasksViewController *vc = [[ZZTasksViewController alloc] initWithTaskType:TaskNormal];
        vc.hidesBottomBarWhenPushed = YES;
        [[UIViewController currentDisplayViewController].navigationController pushViewController:vc animated:YES];
    }
    else if ([typeStr integerValue] == 29) {
        // 跳转到订单详情页
        ZZTaskDetailViewController *vc = [[ZZTaskDetailViewController alloc] initWithTaskID:validDictionary[@"data"][@"pid"]];
        vc.hidesBottomBarWhenPushed = YES;
        [[UIViewController currentDisplayViewController].navigationController pushViewController:vc animated:YES];
    }
    else if ([typeStr integerValue] == 77) {
        // 跳转到订单列表
        ZZTasksViewController *taskVC = [[ZZTasksViewController alloc] initWithTaskType:TaskFree];
        taskVC.hidesBottomBarWhenPushed = YES;
        [[UIViewController currentDisplayViewController].navigationController pushViewController:taskVC animated:YES];
    }
    else if ([typeStr integerValue] == 87) {
        // 跳转到唱趴广场
        UITabBarController *tabs = (UITabBarController*)self.window.rootViewController;
        WEAK_OBJECT(tabs, weakTabs);
        UINavigationController *navCtl = [weakTabs selectedViewController];
        WEAK_OBJECT(navCtl, weakNavCtl);
        ZZKTVPlazaController *controller = [[ZZKTVPlazaController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [weakNavCtl pushViewController:controller animated:YES];
    }
    else if ([typeStr integerValue] == 1000) {
        ChangePriceSuccessView *sv = [[ChangePriceSuccessView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [[UIApplication sharedApplication].keyWindow addSubview:sv];
   }
    else if ([typeStr integerValue] == 4003) {
        // 跳转到活动
        UITabBarController *tabs = (UITabBarController*)self.window.rootViewController;
        UINavigationController *weakNavCtl = [tabs selectedViewController];
        ZZTasksViewController *taskVC = [[ZZTasksViewController alloc] initWithTaskType:TaskFree];
        taskVC.hidesBottomBarWhenPushed = YES;
        [weakNavCtl pushViewController:taskVC animated:YES];
    }
    else if ([typeStr integerValue] == 4008 || [typeStr integerValue] == 4009) {
        // 提醒去申请达人 / 填写微信号
        [[ZZCommossionManager manager] showRemindView:rcDict action:^(NSInteger action) {
            if (action == 0) {
                // 达人
                ZZTabBarViewController *controller = [ZZTabBarViewController sharedInstance];
                if (controller.selectedIndex != 3) {
                    [[ZZTabBarViewController sharedInstance] setSelectIndex:3];
                }
            }
            else {
                // 微信
                ZZWXViewController *controller = [[ZZWXViewController alloc] init];
                controller.hidesBottomBarWhenPushed = YES;
                [[UIViewController currentDisplayViewController].navigationController pushViewController:controller animated:YES];
            }
        }];
    }
    else if ([typeStr integerValue] == 5832) {
        // 已入帐金额推送
        if ([[UIViewController currentDisplayViewController] isKindOfClass: [ZZMyCommissionsController class]]) {
            return;
        }
        ZZMyCommissionsController *controller = [[ZZMyCommissionsController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        UITabBarController *tabs = (UITabBarController*)self.window.rootViewController;
        UINavigationController *weakNavCtl = [tabs selectedViewController];
        [weakNavCtl pushViewController:controller animated:YES];
    }
    else if ([typeStr integerValue] == 5833) {
        // 注册推送
        if ([[UIViewController currentDisplayViewController] isKindOfClass: [ZZMyCommissionsController class]]) {
            ZZMyCommissionsController *controller = [UIViewController currentDisplayViewController];
            [controller jumpTo:CommissionInvited];
            return;
        }
        ZZMyCommissionsController *controller = [[ZZMyCommissionsController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.shouldJump = YES;
        controller.jumpType = CommissionInvited;
        
        UITabBarController *tabs = (UITabBarController*)self.window.rootViewController;
        UINavigationController *weakNavCtl = [tabs selectedViewController];
        [weakNavCtl pushViewController:controller animated:YES];
    }
    else if (rcDict && [typeStr integerValue] != 18 && [typeStr integerValue] != 19 && [typeStr integerValue] != 20 && [typeStr integerValue] != 100 && [typeStr integerValue] != 101 && [typeStr integerValue] != 104&& [typeStr integerValue] != 21&& [typeStr integerValue] != 302 ) {
        
        if ([[UIViewController currentDisplayViewController] isKindOfClass:[ZZRentOrderPaymentViewController class]] ||[[UIViewController currentDisplayViewController] isKindOfClass:[ZZRentOrderPayCompleteViewController class]]) {
            return;
        }
       /*融云啊  你app杀死 fid 就是fid  为什么 app处于后台fid 就变成了tid  tid 变成了fid  **/
       NSString *sendUid = [rcDict objectForKey:@"fId"];
       if ([sendUid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
           sendUid = [rcDict objectForKey:@"tId"];
       }
       /* 融云啊 你让我很惆怅 **/
        [self gotoChatView:sendUid application:[UIApplication sharedApplication]];
    }
    else {
        NSString *messageId = [userInfo objectForKey:@"_id_"];
        if (messageId != nil) {
            [MiPushSDK openAppNotify:messageId];
        }
        ZZNotificationHelper *helper = [[ZZNotificationHelper alloc] init];
        helper.firstLoad = _firstLoad;
        [helper managerNotification:rcDict ? validDictionary[@"data"] : userInfo application:[UIApplication sharedApplication] window:self.window];
    }
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
     [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotifications %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [MiPushSDK bindDeviceToken:deviceToken];
    NSString *token = [self getHexStringForData:deviceToken];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];

    NSLog(@"didRegisterForRemoteNotifications %@", token);
    
    if ([ZZUserHelper shareInstance].isLogin) {
        [[ZZUserHelper shareInstance] updateDevice:token callback:nil];
    }
}

- (NSString *)getHexStringForData:(NSData *)data {
    NSUInteger len = [data length];
    char *chars = (char *)[data bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < len; i ++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    }
    return hexString;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    WeakSelf
    __block UIBackgroundTaskIdentifier backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^ {
        [application endBackgroundTask:backgroundTask];
        weakSelf.backgroundTask = UIBackgroundTaskInvalid;
    }];
    self.backgroundTask = backgroundTask;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [ZZLocalPushManager cancelLocalAllNotification];
    
    [self getLocation];
    [[ZZTabBarViewController sharedInstance] getUnread];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   NSLog(@"PY_进入前台");
    //查询订单支付情况
    NSDictionary *paymentData = [ZZUserDefaultsHelper objectForDestKey:kPaymentData];
    NSString *paymentId = paymentData[@"id"];
    if (paymentId) {
        [ZZThirdPayHelper pingxxRetrieve:paymentId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                //do nothing
            }
            else if (data) {
                [ZZUserDefaultsHelper removeObjectForDestKey:kPaymentData];
                UITabBarController *tabs = (UITabBarController*)self.window.rootViewController;
                if (tabs && [tabs isKindOfClass:[UITabBarController class]]) {
                    UINavigationController *navCtl = [tabs selectedViewController];
                    
                    if ([[[navCtl.viewControllers lastObject] class] isEqual:[ZZPayViewController class]]) {
                        ZZPayViewController *controller = (ZZPayViewController *)[navCtl.viewControllers lastObject];
                        [controller paymentRecall:@{@"type":paymentData[@"type"],@"paid":data[@"paid"]}];
                    }
                    else if ([[[navCtl.viewControllers lastObject] class] isEqual:[ZZRentOrderPaymentViewController class]]) {
                        ZZRentOrderPaymentViewController *controller = (ZZRentOrderPaymentViewController *)[navCtl.viewControllers lastObject];
                        BOOL paid = [data[@"paid"] boolValue];
                        if (paid) {
                            [controller payComplete];
                        }
                    }
                }
                
            }
        }];
    }
    
    // 获取当前的出口IP,并上传服务器
    [self sendCurrentIpAddress];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if ([ZZLiveStreamHelper sharedInstance].connecting) {
        [ZZUserDefaultsHelper setObject:@"内存占用过多" forDestKey:@"内存占用过多"];
        [[ZZLiveStreamHelper sharedInstance] disconnect];
    }
    //结束内购
    [[ZZPayHelper shared] stopManager];

}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}

#pragma mark - Private methods

/*
 根视图
 */
- (void)createRootViewControllerandhJumpToTask:(BOOL)didJumpToTask taskDic:(NSDictionary *)jumpDic {
    WEAK_SELF();
    ZZTabBarViewController *controller = [ZZTabBarViewController sharedInstance];
    WEAK_OBJECT(controller, weakController);
    weakSelf.window.rootViewController = weakController;
    NSLog(@"PY_是否创建根视图");
    _haveLoad = YES;
    _firstLoad = YES;
    if (_remoteInfo) {
        if ([[_remoteInfo objectForKey:@"tabbar"] isEqualToString:@"find"]) {
            [[ZZTabBarViewController sharedInstance] setSelectIndex:1];
        } else {
            [weakSelf managerNotification:_remoteInfo];
        }
    }
    
    _firstLoad = NO;
    if (_schemaModel) {
        [weakSelf managerNextControllerWithModel:_schemaModel];
    }
    
    [[ZZTabBarViewController sharedInstance] showAuthorityView];
    
    [controller.neoHomeCtl jumpToTasks:jumpDic];
}

/*
 根视图
 */
- (void)createRootViewController {
    WEAK_SELF();
    ZZTabBarViewController *controller = [ZZTabBarViewController sharedInstance];
    WEAK_OBJECT(controller, weakController);
    weakSelf.window.rootViewController = weakController;
     NSLog(@"PY_是否创建根视图");
    _haveLoad = YES;
    _firstLoad = YES;
    if (_remoteInfo) {
        if ([[_remoteInfo objectForKey:@"tabbar"] isEqualToString:@"find"]) {
            [[ZZTabBarViewController sharedInstance] setSelectIndex:1];
        } else {
        
            [weakSelf managerNotification:_remoteInfo];
        }
    }
    
    _firstLoad = NO;
    if (_schemaModel) {
        [weakSelf managerNextControllerWithModel:_schemaModel];
    }
    
    [[ZZTabBarViewController sharedInstance] showAuthorityView];
}

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

#pragma mark - Config
- (void)config:(UIApplication *)application {

    [ZZAppDelegateConfig config];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status != kCLAuthorizationStatusNotDetermined) {
        // 注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge |
                            UIUserNotificationTypeSound |
                            UIUserNotificationTypeAlert)
                categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    if (IOS10) {
//        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    
    // 加载的头像 不进行解压
    SDImageCache *canche = [SDImageCache sharedImageCache];
    canche.config.shouldDecompressImages = NO;

    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    downloder.shouldDecompressImages = NO;
}


#pragma mark - Notification Method
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(configNotificationAuthority)
                                                    name:kMsg_AuthorityConfirm
                                                  object:nil];
       
       // 用户登录
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kMsg_UserLogin object:nil];
}

- (void)configNotificationAuthority {
    [MiPushSDK registerMiPush:self];
    [ZZPushMessage configNotification];
}

- (void)userDidLogin {
    [self sendCurrentIpAddress];
}

#pragma mark - 引导页
- (void)loadGuidePage {
    //有些引导页只显示一次
    WEAK_SELF();
    NSString *key = [NSString stringWithFormat:@"IntroPageKey%@",@"2.3.0"];
    NSString *string = [ZZKeyValueStore getValueWithKey:key];
    if (!string) {
        [weakSelf createRootViewController];
        [weakSelf.window makeKeyAndVisible];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        ZZNewGuidView *guidView = [[ZZNewGuidView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        guidView.delegate = weakSelf;
        [weakSelf.window addSubview:guidView];
        [weakSelf.window bringSubviewToFront:guidView];

        [ZZKeyValueStore saveValue:@"haveloadguide" key:key];
    }
    else {
        if (![ZZUserHelper shareInstance].firstHomeGuide) {
            [[ZZTabBarViewController sharedInstance] showGuideView];
        }
        [weakSelf showAdViews];
        [weakSelf.window makeKeyAndVisible];
    }
}

- (void)guideViewDidFinish {
    /**
     *  更新APP的老用户先绑小米推送别名
     */
    if ([ZZUserHelper shareInstance].isLogin) {
        [MiPushSDK setAlias:[ZZUserHelper shareInstance].loginer.uid];
    }
    [self createRootViewController];
    [[ZZTabBarViewController sharedInstance] showGuideView];
}

#pragma mark - 定位
- (void)getLocation {
    _haveGetLocation = NO;
    NSString *string = [ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstinstallapp];
    if ([CLLocationManager locationServicesEnabled] && string) {
        //定位地址
        if (!_LocationManager) {
            _LocationManager = [[CLLocationManager alloc] init];
            _LocationManager.delegate = self;
            _LocationManager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
            _LocationManager.distanceFilter = 100; //控制定位服务移动后更新频率。单位是“米”
        }
        [_LocationManager startUpdatingLocation];
    }
    [ZZKeyValueStore saveValue:@"firstinstallapp" key:[ZZStoreKey sharedInstance].firstinstallapp];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (_haveGetLocation) {
        return;
    }
    _haveGetLocation = YES;
    [ZZUserHelper shareInstance].location = locations[0];
    if ([ZZUserHelper shareInstance].isLogin) {
        [[ZZUserHelper shareInstance] updateUserLocationWithLocation:locations[0]];
    }
    [_LocationManager stopUpdatingLocation];
}

#pragma mark - XHLaunchAd
/*
 广告
 */
- (void)showAdViews {
    NSDictionary *adInfo = [ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].adInfo];
    if (adInfo && [adInfo isKindOfClass:[NSDictionary class]] && !isNullString(adInfo[@"url"]) && [adInfo[@"show"] boolValue]) {
        // 配置广告数据
        XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];

        // 广告停留时间
        if (adInfo[@"time"] && [adInfo[@"time"] integerValue] > 0) {
            imageAdconfiguration.duration = [adInfo[@"time"] integerValue];
        }
        
        // frame
        imageAdconfiguration.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);

        //
        imageAdconfiguration.imageNameOrURLString = adInfo[@"url"];

        // 缓存机制
        imageAdconfiguration.imageOption = XHLaunchAdImageCacheInBackground;

        // 图片填充模式
        imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;

        // 动画
        imageAdconfiguration.showFinishAnimate = ShowFinishAnimateNone;

        // 广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
        imageAdconfiguration.openModel = adInfo;

        // 打开
        [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    }
    
    [self fetchAd];
    [self createRootViewController];
}

- (void)fetchAd {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ZZRequest method:@"GET" path:@"/system/launch/ad" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (!error && [data isKindOfClass:[NSDictionary class]]) {
                [ZZKeyValueStore saveValue:data key:[ZZStoreKey sharedInstance].adInfo];
                if (!isNullString(data[@"url"])) {
                    [XHLaunchAd downLoadImageAndCacheWithURLArray:@[[NSURL URLWithString:data[@"url"]]]];
                }
            }
            else {
                [ZZKeyValueStore cleanObject:[ZZStoreKey sharedInstance].adInfo];
            }
        }];
    });
}

#pragma mark XHLaunchAdDelegate
- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint {
    if (!openModel) {
        return;
    }
    
    NSDictionary *adData = (NSDictionary *)openModel;
    NSString *urlString = adData[@"click_url"];
    NSString *type = adData[@"type"];
    
    if (isNullString(urlString) ) {
        return;
    }
    
    if (!isNullString(urlString) && [type isEqualToString:@"app"]) {
        // 下载的
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else if ([urlString containsString:@"zwmscheme://"]) {
        NSString *jsonString = [urlString stringByReplacingOccurrencesOfString:@"zwmscheme://" withString:@""];
        
        // 自定义的
        if ([urlString containsString:@"ZZTasksViewController"]) {
            NSDictionary *dictionary = [ZZUtils dictionaryWithJsonString:jsonString];
            
            ZZTabBarViewController *controller = [ZZTabBarViewController sharedInstance];
            [controller.neoHomeCtl jumpToTasks:dictionary];
        }
        else if ([urlString containsString:@"ZZMyCommissionsController"]) {
            if (![ZZUtils isUserLogin]) {
                return;
            }
            ZZMyCommissionsController *controller = [[ZZMyCommissionsController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            UITabBarController *tabs = (UITabBarController*)self.window.rootViewController;
            UINavigationController *weakNavCtl = [tabs selectedViewController];
            [weakNavCtl pushViewController:controller animated:YES];
        }
        else {
            
        }
    }
    else {
        // 网页
        if (!isNullString(urlString)) {
            ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
            controller.urlString = urlString;
            controller.isHideBar = YES;
            controller.isFromAD = NO;
            UINavigationController *navCtl = (UINavigationController*)self.window.rootViewController;
            if ([navCtl isKindOfClass: [UINavigationController class]]) {
                [navCtl pushViewController:controller animated:YES];
            }
        }
    }
}

#pragma mark - IP
/*
 获取当前的出口IP,并上传服务器
 */
- (void)sendCurrentIpAddress {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![[ZZUserHelper shareInstance] isLogin]) {
            return;
        }
        
        NSString *ip = [self fetchIPAddress];
        if (isNullString(ip)) {
            return;
        }
        
        if (![self shouldUploadIP:ip]) {
            return;
        }
        
        NSString *uuid = [WBKeyChain keyChainLoadWithKey:DEVICE_ONLY_KEY];
        if (isNullString(uuid)) {
            uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [WBKeyChain keyChainSave:uuid key:DEVICE_ONLY_KEY];
        }
        
        if (isNullString(uuid)) {
            return;
        }

        [ZZRequest method:@"POST"
                     path:[NSString stringWithFormat:@"/api/addUserDevLog?uuid=%@",uuid]
                   params:@{
                       @"from"  : [ZZUserHelper shareInstance].loginer.uid,
                       @"ip"    : ip,
                       @"uuid"  : uuid,
                   }
                     next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (!error && data) {
                [self saveIPAddressTolocal:ip];
            }
        }];
    });
    
}

/*
    获取当前出口IP
 */
- (NSString *)fetchIPAddress {
    NSURL *ipURL = [NSURL URLWithString:H5Url.fetchIpAddress];
    NSURLRequest *request = [NSURLRequest requestWithURL:ipURL];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSMutableString *ip = [[NSMutableString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        //对字符串进行处理，然后进行json解析
        //删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *wanIP = dict[@"cip"];
        return wanIP;
    }
    return nil;
}

- (BOOL)shouldUploadIP:(NSString *)ipAddress {
    if (![[ZZUserHelper shareInstance] isLogin] || isNullString([ZZUserHelper shareInstance].loginer.uid) || isNullString(ipAddress)) {
        return NO;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray<NSDictionary *> *usersArr = [userDefaults objectForKey:@"usersIPAddress"];
    if (!usersArr || usersArr.count == 0) {
        return YES;
    }
    
    NSString *currentDate = [[ZZDateHelper shareInstance] getCurrentExactDay];
    
    __block BOOL didIPMatch = NO;
    [usersArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *uid = obj[@"uid"];
        if (!isNullString(uid) && [uid isEqualToString: [ZZUserHelper shareInstance].loginer.uid]) {
            NSString *updateDate = obj[@"lasteUpdateDate"];
            if (![updateDate isEqualToString:currentDate]) {
                *stop = YES;
                return ;
            }
            
            NSArray *ipsArr = obj[@"ips"];
            if (!ipsArr || ipsArr.count == 0) {
                *stop = YES;
                return;
            }
            
            if ([ipsArr containsObject:ipAddress]) {
                didIPMatch = YES;
                *stop = YES;
            }
        }
    }];
    
    if (didIPMatch) {
        return NO;
    }
    
    return YES;
}

- (void)saveIPAddressTolocal:(NSString *)ipAddress {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![[ZZUserHelper shareInstance] isLogin] || isNullString([ZZUserHelper shareInstance].loginer.uid) || isNullString(ipAddress)) {
            return;
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSMutableArray<NSDictionary *> *usersArr = [[userDefaults objectForKey:@"usersIPAddress"] mutableCopy];
        
        if (!usersArr) {
            usersArr = @[].mutableCopy;
        }
        
        NSString *currentDate = [[ZZDateHelper shareInstance] getCurrentExactDay];
        if (usersArr.count == 0) {
            NSArray *ips = @[ipAddress];
            
            NSDictionary *infos = @{
                @"uid" : [ZZUserHelper shareInstance].loginer.uid,
                @"ips" : ips,
                @"lasteUpdateDate" : currentDate,
            };
            
            [usersArr addObject:infos];
        }
        else {
            __block NSInteger index = -1;
            [usersArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *uid = obj[@"uid"];
                if (!isNullString(uid) && [uid isEqualToString: [ZZUserHelper shareInstance].loginer.uid]) {
                    index = idx;
                    *stop = YES;
                }
            }];
            
            if (index == -1) {
                NSArray *ips = @[ipAddress];
                
                NSDictionary *infos = @{
                    @"uid" : [ZZUserHelper shareInstance].loginer.uid,
                    @"ips" : ips,
                    @"lasteUpdateDate" : currentDate,
                };
                
                [usersArr addObject:infos];
            }
            else {
                NSMutableDictionary *infoDic = [usersArr[index] mutableCopy];
                
                // 时间不相同的话就清空
                NSString *updateDate = infoDic[@"lasteUpdateDate"];
                if (![updateDate isEqualToString:currentDate]) {
                    infoDic[@"ips"] = @[ipAddress];
                }
                else {
                    NSMutableArray *ipsM = [infoDic[@"ips"] mutableCopy];
                    if (ipsM.count == 0) {
                        ipsM = @[].mutableCopy;
                    }
                    if (![ipsM containsObject:ipAddress]) {
                        [ipsM addObject:ipAddress];
                    }
                    
                    infoDic[@"ips"] = ipsM.copy;
                }
                infoDic[@"lasteUpdateDate"] = currentDate;
                
                usersArr[index] = infoDic;
            }
        }
        
        [userDefaults setObject:usersArr.copy forKey:@"usersIPAddress"];
        [userDefaults synchronize];
    });
}

- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data {
    if ([selector isEqualToString:@"bindDeviceToken:"]) {
         NSLog(@"PYregid = %@", data[@"regid"]);
        if ([ZZUserHelper shareInstance].isLogin) {
            [MiPushSDK setAlias:[ZZUserHelper shareInstance].loginer.uid];
        }
    }
}

// Universal Links 通用链接
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    
    //判断是否通过OpenInstall Universal Links 唤起App
    if ([OpenInstallSDK continueUserActivity:userActivity]) {
        return YES;
    }
    //其他代码
    return YES;
}

#pragma mark - OpenInstall
- (void)configureOpenInstall {
    [OpenInstallSDK initWithDelegate:self];
    [self fetchInvitedInfo];
}

- (void)fetchInvitedInfo {
    [[OpenInstallSDK defaultManager] getInstallParmsCompleted:^(OpeninstallData * _Nullable appData) {
        if (appData.data) {
#ifdef DEBUG
            [[OpenInstallSDK defaultManager] reportEffectPoint:@"install" effectValue:1];
#else
                
#endif
        }
    }];
}

#pragma mark - Navigation
- (void)managerNextControllerWithModel:(ZZUrlSchemaModel *)model {
    WEAK_SELF();
    if (model) {
        NSInteger type = [model.type integerValue];
        switch (type) {
            case 0:
            {
                UITabBarController *tabs = (UITabBarController*)weakSelf.window.rootViewController;
                WEAK_OBJECT(tabs, weakTabs);
                UINavigationController *navCtl = [weakTabs selectedViewController];
                WEAK_OBJECT(navCtl, weakNavCtl);
                ZZRentViewController *controller = [[ZZRentViewController alloc] init];
                controller.uid = model.content;
                controller.isFromHome = YES;
                controller.hidesBottomBarWhenPushed = YES;
                [weakNavCtl pushViewController:controller animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)gotoChatView:(NSString *)uid application:(UIApplication *)application {
    UITabBarController *tabs = (UITabBarController*)self.window.rootViewController;
    if (tabs.selectedIndex == 2) {
        ZZNavigationController *navCtl = (ZZNavigationController *)tabs.selectedViewController;
        if ([[navCtl.viewControllers lastObject] isKindOfClass:[ZZChatViewController class]] &&
            [[ZZUserHelper shareInstance].chatUid isEqualToString:uid]) {
            NSLog(@"PY_当前跳转的");
            return;
        }
        else {
            [navCtl popViewControllerAnimated:NO];
        }
    } else {
        ZZNavigationController *navCtl = (ZZNavigationController *)tabs.selectedViewController;
        if ([[navCtl.viewControllers lastObject] isKindOfClass:[ZZChatViewController class]] &&
            [[ZZUserHelper shareInstance].chatUid isEqualToString:uid]) {
            return;
        } else {
            ZZTabBarViewController *tabBar = (ZZTabBarViewController *)tabs;
            tabBar.tabBar.hidden = NO;
            [tabBar setSelectIndex:2];
        }
    }
}

@end
