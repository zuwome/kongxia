//
//  ZZRentOrderWechatWarningView.h
//  zuwome
//
//  Created by qiming xiao on 2019/1/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZRentOrderWechatWarningView : UIView

+ (instancetype)show;

+ (instancetype)showWithTitle:(NSString *)title cancleBlock:(void(^)(void))cancelBlock;

@property (nonatomic, copy) void(^cancelBlock)(void);

@end

@interface WechatWarningView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *okBtn;


@end


NS_ASSUME_NONNULL_END
