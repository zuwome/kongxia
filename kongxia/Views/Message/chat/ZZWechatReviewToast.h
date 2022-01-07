//
//  ZZWechatWarningView.h
//  zuwome
//
//  Created by qiming xiao on 2019/1/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZWechatReviewToast : UIView

+ (instancetype)showWithCancelBlock:(void(^)(void))cancelBlock reviewBlock:(void(^)(void))reviewBlock okBlock:(void(^)(void))okBlock;

@end


@interface ToastWarningView : UIView

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *okButton;

@property (nonatomic, strong) UIButton *reviewButton;

@end

NS_ASSUME_NONNULL_END
