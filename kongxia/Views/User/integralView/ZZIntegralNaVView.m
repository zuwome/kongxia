//
//  ZZIntegralNaVView.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/14.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZIntegralNaVView.h"
@interface ZZIntegralNaVView()
@property (nonatomic,strong) UIButton *leftNavButton;
@property (nonatomic,strong) UIButton *rightNavButton;
@property (nonatomic,strong) UILabel  *titleNaVLab;

@end
@implementation ZZIntegralNaVView

- (instancetype)initWithFrame:(CGRect)frame  titleNavLabTitile:(NSString *)titleNavLabTitile rightTitle:(NSString *)rightTitle {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBCOLOR(39, 39, 39);
        [self addSubview:self.leftNavButton];
        [self addSubview:self.rightNavButton];
        [self addSubview:self.titleNaVLab];
        if (!isNullString(rightTitle)) {
            self.rightNavButton.hidden = NO;
            [self.rightNavButton setTitle:rightTitle forState:UIControlStateNormal];
            
        }else{
            self.rightNavButton.hidden = YES;
        }
        self.titleNaVLab.text = titleNavLabTitile;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.leftNavButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.equalTo(self.mas_centerY).offset(STATUSBARBar_Center);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.rightNavButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.equalTo(self.mas_centerY).offset(STATUSBARBar_Center);
        make.size.mas_equalTo(CGSizeMake(90, 44));
    }];
    
    [self.titleNaVLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(STATUSBARBar_Center);
        make.centerX.equalTo(self);
    }];
    
}

- (UIButton *)rightNavButton {
    if (!_rightNavButton) {
        _rightNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightNavButton addTarget:self action:@selector(navigationRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _rightNavButton.titleLabel.font = CustomFont(15);
        [_rightNavButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _rightNavButton;
}
- (UILabel *)titleNaVLab {
    if (!_titleNaVLab) {
        _titleNaVLab = [[UILabel alloc]init];
        _titleNaVLab.textAlignment = NSTextAlignmentCenter;
        _titleNaVLab.textColor = [UIColor whiteColor];
        _titleNaVLab.font = CustomFont(17);
    }
    return _titleNaVLab;
}

- (UIButton *)leftNavButton {
    if (!_leftNavButton) {
        _leftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _leftNavButton.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);
//        _leftNavButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
         [_leftNavButton addTarget:self action:@selector(navigationLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_leftNavButton setImage:[UIImage imageNamed:@"icReturn"] forState:UIControlStateNormal];
    }
    return _leftNavButton;
}


/**
 右侧导航的点击事件
 */
- (void)navigationRightBtnClick {
    if (self.rightNavClickBlock) {
        self.rightNavClickBlock();
    }
}

/**
 左侧导航的点击事件
 */
- (void)navigationLeftBtnClick
{
    [ZZHUD dismiss];
    if (self.leftNavClickBlock) {
        self.leftNavClickBlock();
    }
}
@end
