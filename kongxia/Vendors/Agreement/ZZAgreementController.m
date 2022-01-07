//
//  ZZAgreementController.m
//  zuwome
//
//  Created by YuTianLong on 2017/9/27.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZAgreementController.h"
#import "ZZPrivacyAgreementView.h"
#import "ZZAgreementTipsView.h"

#define PrivacyAgreementIfNeeded    (@"PrivacyAgreementIfNeeded")

@interface ZZAgreementController ()

@property (nonatomic, copy) void (^agreeBlock)();
@property (nonatomic, strong) ZZPrivacyAgreementView *agreementView;
@property (nonatomic, strong) ZZAgreementTipsView *tipsView;

@end

@implementation ZZAgreementController

#pragma mark - Private methods

- (void)createAgreementView {
    
    WeakSelf
    self.agreementView = [ZZPrivacyAgreementView new];
    [self.agreementView setAgreeBlock:^(BOOL agree) {
        [weakSelf.agreementView dismiss];
        if (agree) {
            [weakSelf agreeClick];
            BLOCK_SAFE_CALLS(weakSelf.agreeBlock);
        } else {
            [weakSelf showAlertView];
        }
    }];
    [self.agreementView show:YES];
}

// 显示条款
- (void)showPrivacyAgreement {
    [self.agreementView show:YES];
}

// 显示Alert
- (void)showAlertView {
    WeakSelf    
    self.tipsView = [ZZAgreementTipsView new];
    [self.tipsView setDoneBlock:^{
        [weakSelf.tipsView dismiss];
        [weakSelf showPrivacyAgreement];
    }];
    [self.tipsView show:YES];
}

- (void)agreeClick {
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:PrivacyAgreementIfNeeded];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Publick methods

- (void)showPrivacyAgreementAgreeBlock:(void (^)())completed {
    self.agreeBlock = completed;
    
    if (!isNullString([[NSUserDefaults standardUserDefaults] objectForKey:PrivacyAgreementIfNeeded])) {
        return ;
    }
    WeakSelf
    [NSObject asyncWaitingWithTime:2.0f completeBlock:^{
        [weakSelf createAgreementView];
    }];
}

@end
