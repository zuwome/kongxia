//
//  ZZBanedHelper.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/18.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZBanedHelper.h"

@implementation ZZBanedHelper

+ (void)showBan:(id)data {
    ZZUser *user = nil;
    if (![data isKindOfClass: [ZZUser class]]) {
        user = [ZZUser yy_modelWithJSON:data];
    }
    else {
        user = data;
    }
    if (![self canShow:user]) {
        return;
    }
    
    if ([user.ban.cate isEqualToString:@"1"]) {
        [self showWarningView:user];
    }
    else {
        [self showBannedView];
    }
}

+ (void)showWarningView:(ZZUser *)user {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"封禁提示" message:user.ban.reason preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"知道了(10s)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self readWarningOrBanned:user];
        }];
        
        doneAction.enabled = NO;
        [alertController addAction:doneAction];
        [self createCountDown:doneAction];
        [[UIViewController currentDisplayViewController] presentViewController:alertController animated:YES completion:nil];
    });
}

+ (void)showBannedView {
    if (![self canShow:[ZZUserHelper shareInstance].loginer]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"封禁提示" message:[ZZUserHelper shareInstance].loginer.ban.reason preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self readWarningOrBanned:[ZZUserHelper shareInstance].loginer];
        }];
       
        [alertController addAction:doneAction];
        
        [[UIViewController currentDisplayViewController] presentViewController:alertController animated:YES completion:nil];
    });
}

+ (BOOL)canShow:(ZZUser *)user {
    if (!user) {
        return NO;
    }
    
    //是不是本人
    if (![user.uid isEqualToString: [ZZUserHelper shareInstance].loginer.uid]) {
        return NO;
    }
    
    if (!user.ban) {
        return NO;
    }
    
    if (user.ban.read) {
        return NO;
    }
    
    if (![user.ban.cate isEqualToString:@"1"] && !user.banStatus) {
        // 被封禁
        return NO;
    }

    return YES;
}

+ (void)createCountDown:(UIAlertAction *)action {
    
       __block NSInteger time = 10; //倒计时时间
       dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
       dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
       
       dispatch_source_set_timer(timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0); //每秒执行
       
       dispatch_source_set_event_handler(timer, ^{
           
           if(time <= 0){ //倒计时结束，关闭
               
               dispatch_source_cancel(timer);
               
               dispatch_async(dispatch_get_main_queue(), ^{
                   [action setValue:@"知道了" forKey:@"title"];
                   action.enabled = YES;
               });
               
           }
           else{
               time--;
               dispatch_async(dispatch_get_main_queue(), ^{
                   [action setValue:[NSString stringWithFormat:@"知道了(%lds)", time] forKey:@"title"];
               });
           }
       });
                    
       dispatch_resume(timer);
}

#pragma mark - Request
+ (void)readWarningOrBanned:(ZZUser *)user {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!user) {
            return;
        }
        [ZZRequest method:@"POST" path:@"/api/readBanUserStatus" params:@{@"uid": user.uid} next:nil];
    });
    
}

@end
