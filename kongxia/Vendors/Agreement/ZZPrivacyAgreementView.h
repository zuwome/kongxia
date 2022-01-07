//
//  ZZPrivacyAgreementView.h
//  zuwome
//
//  Created by YuTianLong on 2017/9/27.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZPrivacyAgreementView : UIView

- (void)show:(BOOL)animated;

- (void)dismiss;

@property (nonatomic, copy) void (^agreeBlock)(BOOL agree);

@end
