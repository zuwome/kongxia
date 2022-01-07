//
//  ZZFastSuccessAlert.h
//  zuwome
//
//  Created by YuTianLong on 2018/1/4.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FastSuccessToastType) {
    ToastSuccess = 0, // 开通成功
    ToastReviewing,   // 开通成功正在人工审核头像
};

@interface ZZFastSuccessAlert : UIView

@property (nonatomic, assign) BOOL isAvatarReviewing;

@property (nonatomic, copy) dispatch_block_t touchSure;

@property (nonatomic, assign) FastSuccessToastType toastType;

+ (instancetype)showWithType:(FastSuccessToastType)type action:(void(^)(void))action;

@end

@interface ZZFastToastView: UIImageView

@property (nonatomic, assign) FastSuccessToastType toastType;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIScrollView *contentScrollView;

- (void)configToastInfoWithType:(FastSuccessToastType)type;

@end
