//
//  ZZRentSuccessShadowView.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/7.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZRentSuccessShadowView.h"

@interface ZZRentSuccessShadowView()
@property (nonatomic,strong) UILabel *robTaskLab;
@property (nonatomic,strong) UIButton *sureButton;
@property (nonatomic,strong) UIView *lineView;

/**
 说明的标题图片
 */
@property (nonatomic,strong) UIImageView *instructionsTitleImgView;

/**
  说明的标题
 */
@property (nonatomic,strong) UILabel *instructionsTitleLab;

@end
@implementation ZZRentSuccessShadowView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15;
        self.layer.shadowColor = kBlackColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(5, 3);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 3;
        [self addSubview:self.robTaskLab];
        [self addSubview:self.lineView];
        [self addSubview:self.instructionsTitleImgView];
        [self addSubview:self.instructionsTitleLab];
        [self addSubview:self.sureButton];
        [self addSubview:self.lineView];
        [self addSubview:self.morePromptLab];
        [self addSubview:self.instructionsLab];
        [self addSubview:self.openSwitch];
    }
    return self;
}
- (UILabel *)robTaskLab {
    if (!_robTaskLab) {
        _robTaskLab = [[UILabel alloc]init];
        _robTaskLab.font = [UIFont systemFontOfSize:15];
        _robTaskLab.textColor = kBlackColor;
        _robTaskLab.text = @"抢任务通知";
    }
    return _robTaskLab;
}
- (UILabel *)morePromptLab {
    if (!_morePromptLab) {
        _morePromptLab = [[UILabel alloc]init];
        _morePromptLab.font = [UIFont systemFontOfSize:15];
        _morePromptLab.textColor = RGBCOLOR(171, 171, 171);
//        _morePromptLab.text = @"更多任务选择，获取更多收益机会";
    }
    return _morePromptLab;
}
- (UISwitch *)openSwitch {
    if (!_openSwitch) {
        _openSwitch = [[UISwitch alloc]init];
        _openSwitch.on = YES;
        _openSwitch.onTintColor = kYellowColor;
    }
    return _openSwitch;
}
- (UILabel *)instructionsLab {
    if (!_instructionsLab) {
        _instructionsLab = [[UILabel alloc]init];
        _instructionsLab.numberOfLines = 0;
        _instructionsLab.font = [UIFont systemFontOfSize:15];
        _instructionsLab.textColor = RGBCOLOR(171, 171, 171);
//        _instructionsLab.text = @"开启抢任务通知，及时抢其他用户发布的邀约，如果用户选择了你，邀约完成即可获得收益。";
    }
    return _instructionsLab;
}
- (UIImageView *)instructionsTitleImgView {
    if (!_instructionsTitleImgView) {
        _instructionsTitleImgView = [[UIImageView alloc]init];
        _instructionsTitleImgView.image = [UIImage imageNamed:@"bgShanzu_rent"];
    }
    return _instructionsTitleImgView;
}
- (UILabel *)instructionsTitleLab {
    if (!_instructionsTitleLab) {
        _instructionsTitleLab = [[UILabel alloc]init];
        _instructionsTitleLab.text = @"什么是闪租？";
        _instructionsTitleLab.font = [UIFont systemFontOfSize:15];
        _instructionsTitleLab.textColor = kBlackColor;
    }
    return _instructionsTitleLab;
}
- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage imageNamed:@"rectangle6"] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _sureButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(237, 237, 237);
    }
    return _lineView;
}
- (void)sureButtonClick:(UIButton *)sender {
     NSLog(@"PY_同意开启闪聊");
    if (self.sureCallBlock) {
        self.sureCallBlock();
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.robTaskLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(21);
        make.width.mas_equalTo(100);
        make.top.offset(36);
    }];
    
    [self.morePromptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.robTaskLab.mas_bottom).offset(11);
        make.left.offset(21);
        make.height.equalTo(@20);
    }];
    
    [self.openSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(AdaptedHeight(47));
        make.right.offset(-17);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(21);
        make.right.offset(-21);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.morePromptLab.mas_bottom).offset(18);
    }];
    
    [self.instructionsTitleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(22);
        make.top.equalTo(self.lineView.mas_bottom).offset(0);
    }];
    [self.instructionsTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.instructionsTitleImgView.mas_centerY);
        make.left.offset(22+33);

    }];
    [self.instructionsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(22.5);
        make.right.offset(-22.5);
        make.top.equalTo(self.instructionsTitleImgView.mas_bottom).offset(0);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.sureButton.mas_height).multipliedBy(300/49.0f);;
        make.height.equalTo(@49);
        make.bottom.offset(-23);
    }];
}
@end
