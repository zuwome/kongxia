//
//  ZZNotificationHelper.m
//  zuwome
//
//  Created by angBiu on 16/8/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZNotificationHelper.h"

#import "ZZTabBarViewController.h"
#import "ZZOrderDetailViewController.h"
#import "ZZRentViewController.h"
#import "ZZMemedaAnswerDetailViewController.h"
#import "ZZMessageNotificationViewController.h"
#import "ZZLinkWebViewController.h"
#import "ZZChatViewController.h"
#import "ZZPlayerViewController.h"
#import "ZZMessageBoxViewController.h"
#import "ZZMessageSystemViewController.h"
#import "ZZNotificationModel.h"

#import "ZZBanAlertView.h"

#import <RongIMKit/RongIMKit.h>

@interface ZZNotificationHelper ()

@property (nonatomic, strong) ZZBanAlertView *banAlertView;

@end

@implementation ZZNotificationHelper
{
    UIWindow            *_window;
}

- (void)managerNotification:(NSDictionary *)userInfo application:(UIApplication *)application window:(UIWindow *)window
{
    NSString *typeStr = [userInfo objectForKey:@"type"];
    NSLog(@"PY_收到通知%s %@",__func__,typeStr);
    _window = window;
    UITabBarController *weaktabs = (UITabBarController*)_window.rootViewController;
    WEAK_OBJECT(weaktabs, tabs);
    UINavigationController *weakNavCtl = [tabs selectedViewController];
    WEAK_OBJECT(weakNavCtl, navCtl);
    if (typeStr) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_PushNotification object:nil userInfo:userInfo];
        
        ZZNotificationModel *model = [[ZZNotificationModel alloc] initWithDictionary:userInfo error:nil];
        
        NSInteger type = [typeStr integerValue];
        
        if (type == 7 || type == 8) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_OrderStatusChante object:nil userInfo:userInfo];

            if ([[navCtl.viewControllers lastObject] isKindOfClass:[ZZOrderDetailViewController class]]) {
                return;
            }
            if ([[navCtl.viewControllers lastObject] isKindOfClass:[ZZChatViewController class]]) {
                return;
            }
        }
        if ((application.applicationState == UIApplicationStateActive||application.applicationState == UIApplicationStateInactive) && !_firstLoad) {
            switch (type) {
                case 3:
                case 4:
                case 7:
                case 8:
                {
                    [self removeBanView];
                    [[UIViewController currentDisplayViewController] showOKCancelAlertWithTitle:@"提示" message:model.msg cancelTitle:@"取消" cancelBlock:nil okTitle:model.btnTitle okBlock:^{
                        [self pushNavigationType:type navCtl:navCtl model:model];
                    }];
                }
                    break;
                case 11:
                {
                    [self removeBanView];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_PushSystemPacket object:nil userInfo:userInfo];
                }
                    break;
                case 14:
                {
                    [self removeBanView];
                    ZZUser *user = [ZZUserHelper shareInstance].loginer;
                    if (user) {
                        user.banStatus = YES;
                        [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                    }
                    _banAlertView = [[ZZBanAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    _banAlertView.contentLabel.text = model.msg;
                    [_window addSubview:_banAlertView];
                }
                    break;
                case 15:
                case 16:
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UserErrorInfo object:nil];
                }
                    break;
                case 17:
                {
                }
                    break;
                case 18: {
                    
                }
                    break;
                case 19: {//防融云假死，走融云小米
                    [NSObject asyncWaitingWithTime:1.5 completeBlock:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ConnectPushNotification object:nil userInfo:userInfo];
                    }];
                }   break;
                case 20: {//防融云假死，走融云小米
                    [NSObject asyncWaitingWithTime:1.5 completeBlock:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ConnectPushNotification object:nil userInfo:userInfo];
                    }];
                }
                    break;
                case 21: {// 公众号充值的回调，通知客户端要去更新么币余额 (防融云假死，走融云小米)
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_PublicRecharge object:nil userInfo:userInfo];
                    [self gotoMessageSystemViewController:navCtl];
                }
                    break;
                case 100: {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_CancelConnect object:nil userInfo:userInfo];
                }
                    break;
                case 101://防融云假死，走融云小米
                {
                    [NSObject asyncWaitingWithTime:1.5 completeBlock:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_RefuseConnect object:nil userInfo:userInfo];
                    }];
                }
                    break;
                case 104: {//防融云假死，走融云小米
                    [NSObject asyncWaitingWithTime:1.5 completeBlock:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ConnectVideoStar object:nil userInfo:userInfo];
                    }];
                }
                    break;
                    case 302:
                {
                    [self gotoMessageSystemViewController:navCtl];

                }
                    break;
                default:
                    break;
            }
        } else {
            [self removeBanView];

            if (type == 18) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_NewPublishOrder object:nil userInfo:userInfo];
            } else if (type == 19 || type == 20) {

                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ConnectPushNotification object:nil userInfo:userInfo];
                
            } else if (type == 21) {// 公众号充值的回调，通知客户端要去更新么币余额 (防融云假死，走融云小米)
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_PublicRecharge object:nil userInfo:userInfo];
                [self gotoMessageSystemViewController:navCtl];
            } else if (type == 100) {//防融云假死，走融云小米
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_CancelConnect object:nil userInfo:userInfo];
            }
            else if (type == 101) {//防融云假死，走融云小米
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_RefuseConnect object:nil userInfo:userInfo];
            } else if (type == 104) {//防融云假死，走融云小米
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ConnectVideoStar object:nil userInfo:userInfo];
            }else if (type == 302) {
                    [self gotoMessageSystemViewController:navCtl];
            }
            
            else {
                [self pushNavigationType:type navCtl:navCtl model:model];
            }
        }
    }
}

- (void)removeBanView
{
    if (_banAlertView) {
        [_banAlertView removeFromSuperview];
    }
}

- (void)pushNavigationType:(NSInteger)type navCtl:(UINavigationController *)nav model:(ZZNotificationModel *)model {
    
    switch (type) {
        case 1:
        {
            if (model.url) {
                [self gotoLinkWebView:nav model:model];
            } else {
                [self gotoMessageSystem:nav model:model];
            }
        }
            break;
        case 2:
        {
            [self gotoUserPage:nav model:model];
        }
            break;
        case 3:
        {
            [self gotoAnswerPage:nav model:model];
        }
            break;
        case 4:
        case 5:
        case 6:
        {
            [self gotoMemedaDetail:nav model:model];
        }
            break;
        case 7:
        {
            if (model.from_user) {
                [self gotoChatView:nav model:model];
            } else {
                [self gotoOrderDetail:nav model:model];
            }
        }
            break;
        case 8:
        {
            [self gotoChatView:nav model:model];
        }
            break;
        case 9:
        {
            [self gotoSKDetailView:nav model:model];
        }
            break;
        case 11:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_PushSystemPacket object:nil userInfo:nil];
        }
            break;
        case 13:
        {
//            [self gotoGetPacketView:nav model:model];
        }
            break;
        case 17:
        {
            [self gotoMessageBoxView:nav model:model];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Navigation

/**
 去H5的网页


 */
- (void)gotoLinkWebView:(UINavigationController *)navCtl model:(ZZNotificationModel *)model
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
        controller.urlString = model.url;
        controller.hidesBottomBarWhenPushed = YES;
        [navCtl pushViewController:controller animated:YES];
    });
}


/**
 去消息通知界面
 */
- (void)gotoMessageSystem:(UINavigationController *)navCtl model:(ZZNotificationModel *)model
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZZMessageNotificationViewController *controller = [[ZZMessageNotificationViewController alloc] init];
        controller.selectIndex = 1;
        controller.hidesBottomBarWhenPushed = YES;
        [navCtl pushViewController:controller animated:YES];
    });
}

- (void)gotoUserPage:(UINavigationController *)navCtl model:(ZZNotificationModel *)model
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZZRentViewController *controller = [[ZZRentViewController alloc] init];
        controller.uid = model.user_id;
        controller.hidesBottomBarWhenPushed = YES;
        [navCtl pushViewController:controller animated:YES];
    });
}

- (void)gotoAnswerPage:(UINavigationController *)navCtl model:(ZZNotificationModel *)model
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZZMemedaAnswerDetailViewController *controller = [[ZZMemedaAnswerDetailViewController alloc] init];
        controller.mid = model.mmd_id;
        controller.hidesBottomBarWhenPushed = YES;
        [navCtl pushViewController:controller animated:YES];
    });
}

- (void)gotoMemedaDetail:(UINavigationController *)navCtl model:(ZZNotificationModel *)model
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
        controller.mid = model.mmd_id;
        controller.hidesBottomBarWhenPushed = YES;
        [navCtl pushViewController:controller animated:YES];
        if (!navCtl.isNavigationBarHidden) {
            controller.popNotHide = YES;
        }
    });
}

- (void)gotoOrderDetail:(UINavigationController *)navCtl model:(ZZNotificationModel *)model
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZZOrderDetailViewController *controller = [[ZZOrderDetailViewController alloc] init];
        controller.orderId = model.order;
        controller.hidesBottomBarWhenPushed = YES;
        [navCtl pushViewController:controller animated:YES];
    });
}

- (void)gotoChatView:(UINavigationController *)navCtl model:(ZZNotificationModel *)model
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZZChatViewController *controller = [[ZZChatViewController alloc] init];
        if (model.from_user) {
            controller.uid = model.from_user;
        } else {
            controller.uid = model.uid;
        }
        controller.hidesBottomBarWhenPushed = YES;
        [navCtl pushViewController:controller animated:YES];
    });
}

- (void)gotoSKDetailView:(UINavigationController *)navCtl model:(ZZNotificationModel *)model
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
        controller.skId = model.sk_id;
        controller.hidesBottomBarWhenPushed = YES;
        [navCtl pushViewController:controller animated:YES];
        if (!navCtl.isNavigationBarHidden) {
            controller.popNotHide = YES;
        }
    });
}

- (void)gotoMessageBoxView:(UINavigationController *)navCtl model:(ZZNotificationModel *)model
{
    if ([[navCtl.viewControllers lastObject] isKindOfClass:[ZZMessageBoxViewController class]]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_ReceiveMessageBox object:nil];
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZZMessageBoxViewController *controller = [[ZZMessageBoxViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [navCtl pushViewController:controller animated:YES];
    });
}
/**
 去系统消息系统
 */
- (void)gotoMessageSystemViewController:(UINavigationController *)navCtl {
    ZZMessageSystemViewController *sysCtl = [[ZZMessageSystemViewController alloc] init];
    if ([[ZZUserHelper shareInstance].unreadModel.system_msg integerValue]>0) {
        [ZZUserHelper shareInstance].unreadModel.system_msg = @0;
    }
    sysCtl.hidesBottomBarWhenPushed = YES;
    [navCtl pushViewController:sysCtl animated:YES];
}

@end
