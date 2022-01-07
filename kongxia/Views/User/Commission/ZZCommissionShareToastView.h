//
//  ZZCommissionShareToastView.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZCommissionShareToastView : UIView

+ (void)show;

@end

@interface ZZCommissionShareToastDoubleCheckView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIView *linkView;

@property (nonatomic, strong) UIView *momentView;

@property (nonatomic, strong) UIView *weChatView;

@end

