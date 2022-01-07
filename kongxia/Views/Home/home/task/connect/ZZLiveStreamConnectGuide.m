//
//  ZZLiveStreamConnectGuide.m
//  zuwome
//
//  Created by angBiu on 2017/8/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLiveStreamConnectGuide.h"

@interface ZZLiveStreamConnectGuide ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *topImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation ZZLiveStreamConnectGuide


/**
 当用户第一次进入的时候调用的引导
 */
+ (void)liveStreamConnectGuideWhenUserFirstInto {
    if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstConnectSuccessGuide]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ZZLiveStreamConnectGuide *guideView = [[ZZLiveStreamConnectGuide alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [[UIApplication sharedApplication].keyWindow addSubview:guideView];
            [ZZKeyValueStore saveValue:@"firstConnectSuccessGuide" key:[ZZStoreKey sharedInstance].firstConnectSuccessGuide];
        });
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)sureBtnClick
{
    [self removeFromSuperview];
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        CGFloat scale = SCREEN_WIDTH/375.0;
        
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 4;
        _bgView.clipsToBounds = YES;
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.width.mas_equalTo(317*scale);
        }];
        
        self.topImgView.image = [UIImage imageNamed:@"icon_livestream_connect_guide"];
        self.titleLabel.text = @"欢迎来到1V1视频通话";
        self.contentLabel.attributedText = [ZZUtils setLineSpace:@"1V1视频过程中，请遵守「空虾」平台行为规范并保持良好的社交礼仪。对于违规用户「空虾」会视情节严重给予相应处罚 " space:5 fontSize:15 color:HEXCOLOR(0x979797)];
        [self.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgView;
}

- (UIImageView *)topImgView
{
    if (!_topImgView) {
        CGFloat scale = SCREEN_WIDTH/375.0;
        
        _topImgView = [[UIImageView alloc] init];
        [_bgView addSubview:_topImgView];
        
        [_topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(_bgView);
            make.height.mas_equalTo(141*scale);
        }];
    }
    return _topImgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackColor;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_topImgView.mas_bottom).offset(20);
        }];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXCOLOR(0x979797);
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        [_bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(25);
            make.right.mas_equalTo(_bgView.mas_right).offset(-25);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(8);
        }];
    }
    return _contentLabel;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _sureBtn.backgroundColor = kYellowColor;
        [_bgView addSubview:_sureBtn];
        
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(17);
            make.right.mas_equalTo(_bgView.mas_right).offset(-17);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(12);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-12);
        }];
    }
    return _sureBtn;
}

@end
