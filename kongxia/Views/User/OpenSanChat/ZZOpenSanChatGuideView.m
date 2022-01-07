//
//  ZZOpenSanChatGuideView.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/7.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOpenSanChatGuideView.h"
@interface ZZOpenSanChatGuideView()
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIImageView *boomImageView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *instructionsLab;

@property (nonatomic,strong) UILabel *instructionsDetailOneLab;

@property (nonatomic,strong) UILabel *instructionsDetailTwoLab;

@end
@implementation ZZOpenSanChatGuideView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 7;
        [self setUI];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self.boomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.right.offset(-17);
        make.top.equalTo(self.bgImageView.mas_bottom).offset(15);
        make.height.equalTo(self.boomImageView.mas_width).multipliedBy(126/285.5f);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.right.offset(-17);
        make.top.equalTo(self.leftImageView.mas_bottom).offset(13);
        make.height.equalTo(self.boomImageView.mas_width).multipliedBy(126/285.5f);

    }];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab.mas_centerY);
        make.right.equalTo(self.titleLab.mas_left).offset(-3.5);
        make.left.offset(2);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab.mas_centerY);
        make.left.equalTo(self.titleLab.mas_right).offset(3.5);
        make.right.offset(-2);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.offset(19);
    }];
    [self.instructionsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(31);
        make.right.offset(-31);
        make.top.greaterThanOrEqualTo(self.boomImageView.mas_top).offset(14);
        make.height.equalTo(@20);
    }];
    [self.instructionsDetailOneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(31);
        make.right.offset(-31);
        make.top.equalTo(self.instructionsLab.mas_bottom).offset(14);
        make.height.greaterThanOrEqualTo(@20);
    }];
    [self.instructionsDetailTwoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(31);
        make.right.offset(-31);
        make.top.equalTo(self.instructionsDetailOneLab.mas_bottom).offset(14);
        make.bottom.lessThanOrEqualTo(self.boomImageView.mas_bottom).offset(-10);
        make.height.greaterThanOrEqualTo(@20);
    }];

}
- (void)setUI{
    [self addSubview:self.boomImageView];
    [self addSubview:self.bgImageView];
    [self addSubview:self.leftImageView];
    [self addSubview:self.rightImageView];
    [self addSubview:self.titleLab];
    [self addSubview:self.instructionsDetailTwoLab];

    [self addSubview:self.instructionsDetailOneLab];

    [self addSubview:self.instructionsLab];

}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = ADaptedFontBoldSize(16);
        _titleLab.text = @"开通流程";
        _titleLab.textColor = RGBCOLOR(226, 121, 104);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLab;
}
- (UIImageView *)boomImageView {
    if (!_boomImageView) {
        _boomImageView =  [[UIImageView alloc]init];
        _boomImageView.image = [UIImage imageNamed:@"rent_openChat_boom"];
        _boomImageView.contentMode = UIViewContentModeScaleAspectFit;

    }
    return _boomImageView;
}
-(UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"rent_openChat_bgView"];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bgImageView;
}
-(UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init];
        _rightImageView.image = [UIImage imageNamed:@"rent_openChat_right"];
    }
    return _rightImageView;
}
- (UILabel *)instructionsLab {
    if (!_instructionsLab) {
        _instructionsLab = [[UILabel alloc]init];
        _instructionsLab.textColor = kBlackColor;
        _instructionsLab.text = @"什么是视频技能咨询";
        _instructionsLab.font =ADaptedFontBoldSize(17);
    }
    return _instructionsLab;
}
- (UILabel *)instructionsDetailOneLab {
    if (!_instructionsDetailOneLab) {
        _instructionsDetailOneLab = [[UILabel alloc]init];
        _instructionsDetailOneLab.numberOfLines = 0;
        _instructionsDetailOneLab.textColor = kBlackColor;
        _instructionsDetailOneLab.text = @"线上视频分享技能经验，视频咨询按分钟获取收益";
        _instructionsDetailOneLab.font = CustomFont(15);
    }
    return _instructionsDetailOneLab;
}
- (UILabel *)instructionsDetailTwoLab {
    if (!_instructionsDetailTwoLab) {
        _instructionsDetailTwoLab  = [[UILabel alloc]init];
        _instructionsDetailTwoLab.numberOfLines = 0;
        _instructionsDetailTwoLab.textColor = kBlackColor;
        _instructionsDetailTwoLab.text = @"视频咨询首页推荐，获得更多曝光机会";
        _instructionsDetailTwoLab.font = CustomFont(15);
        
    }
    return _instructionsDetailTwoLab;
}
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]init];
        _leftImageView.image = [UIImage imageNamed:@"rent_openChat_left"];
    }
    return _leftImageView;
}


@end
