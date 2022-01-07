//
//  ZZChatPacketInfoView.m
//  zuwome
//
//  Created by angBiu on 2016/11/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatPacketInfoView.h"

@interface ZZChatPacketInfoView ()

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *downBtn;
@property (nonatomic, strong) UIImageView *downImgView;
@property (nonatomic, strong) UIView *priceBgView;
@property (nonatomic, strong) UILabel *packetPriceLabel;
@property (nonatomic, strong) UILabel *servicePriceLabel;

@end

@implementation ZZChatPacketInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _bgBtn = [[UIButton alloc] initWithFrame:frame];
        _bgBtn.backgroundColor = kBlackTextColor;
        _bgBtn.alpha = 0.8;
        [_bgBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bgBtn];
        
        [self showView];
        
        
        if (![ZZUserHelper shareInstance].configModel.yj) {
            self.downBtn.userInteractionEnabled = NO;
        }
    }
    
    return self;
}

#pragma mark - UIButtonMethod

- (void)showView
{
    self.bgImgView.transform = CGAffineTransformMakeScale(0.2f, 0.2f);
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.bgImgView.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideView
{
    _bgBtn.hidden = YES;
    
    self.bgImgView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgImgView.transform=CGAffineTransformMakeScale(0.1f, 0.1f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showPriceInfoView
{
    if (self.priceBgView.hidden) {
        self.priceBgView.hidden = NO;
        _downImgView.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.priceBgView.hidden = YES;
        _downImgView.transform = CGAffineTransformMakeRotation(2* M_PI);
    }
}

#pragma mark - lazy

- (UIImageView *)bgImgView
{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"icon_chat_packet_info_bg"];
        _bgImgView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(100, image.size.width/2, 20, image.size.width/2) resizingMode:UIImageResizingModeStretch];
        _bgImgView.userInteractionEnabled = YES;
        [self addSubview:_bgImgView];
        
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(30);
            make.right.mas_equalTo(self.mas_right).offset(-30);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        _bgImgView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        
        UIImageView *cancelImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 18, 18)];
        cancelImgView.image = [UIImage imageNamed:@"icon_read_cancel"];
        [_bgImgView addSubview:cancelImgView];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [btn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        [_bgImgView addSubview:btn];
        
        _headImgView = [[ZZHeadImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        [_bgImgView addSubview:_headImgView];
//        _headImgView.center = CGPointMake(width/2, _bgImgView.height * 90/293.0);
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgImgView.mas_centerX);
            make.centerY.mas_equalTo(_bgImgView.mas_top).offset(90);
            make.size.mas_equalTo(CGSizeMake(64, 64));
        }];
        
        _moneyLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentCenter textColor:[UIColor whiteColor] fontSize:28 text:@"¥6.00"];
        [_bgImgView addSubview:_moneyLabel];
        
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgImgView.mas_centerX);
            make.top.mas_equalTo(_headImgView.mas_bottom).offset(30);
        }];
        
        _statusLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentCenter textColor:kYellowColor fontSize:15 text:@"红包已过期"];
        [_bgImgView addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.downBtn.mas_bottom).offset(55);
            make.centerX.mas_equalTo(_bgImgView.mas_centerX);
        }];
        
        self.priceBgView.hidden = YES;
        
        _timeLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentCenter textColor:[UIColor whiteColor] fontSize:13 text:@"2016-11-11 11:11:11过期"];
        [_bgImgView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_statusLabel.mas_bottom).offset(8);
            make.centerX.mas_equalTo(_bgImgView.mas_centerX);
            make.bottom.mas_equalTo(_bgImgView.mas_bottom).offset(-10);
        }];
    }
    
    return _bgImgView;
}

- (UIButton *)downBtn
{
    if (!_downBtn) {
        _downBtn = [[UIButton alloc] init];
        [_downBtn addTarget:self action:@selector(showPriceInfoView) forControlEvents:UIControlEventTouchUpInside];
        [_bgImgView addSubview:_downBtn];
        
        [_downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgImgView.mas_centerX);
            make.top.mas_equalTo(_moneyLabel.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(80, 15));
        }];
        
        _downImgView = [[UIImageView alloc] init];
        _downImgView.image = [UIImage imageNamed:@"icon_amountdetail_down"];
        _downImgView.userInteractionEnabled = NO;
        [_downBtn addSubview:_downImgView];
        
        [_downImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_downBtn.mas_top);
            make.centerX.mas_equalTo(_downBtn.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(15.5, 8));
        }];
    }
    return _downBtn;
}

- (UIView *)priceBgView
{
    if (!_priceBgView) {
        _priceBgView = [[UIView alloc] init];
        [_bgImgView addSubview:_priceBgView];
        
        [_priceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_bgImgView);
            make.top.mas_equalTo(_downBtn.mas_bottom);
        }];
        
        UILabel *packetTitleLabel = [[UILabel alloc] init];
        packetTitleLabel.textColor = HEXACOLOR(0xffffff, 0.75);
        packetTitleLabel.font = [UIFont systemFontOfSize:12];
        packetTitleLabel.text = @"打赏金额";
        [_priceBgView addSubview:packetTitleLabel];
        
        [packetTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_priceBgView.mas_left).offset((SCREEN_WIDTH - 60)/4.0);
            make.top.mas_equalTo(_priceBgView.mas_top);
        }];
        
        _packetPriceLabel = [[UILabel alloc] init];
        _packetPriceLabel.textAlignment = NSTextAlignmentCenter;
        _packetPriceLabel.textColor = HEXACOLOR(0xffffff, 0.75);
        _packetPriceLabel.font = [UIFont systemFontOfSize:12];
        _packetPriceLabel.text = @"￥10";
        [_priceBgView addSubview:_packetPriceLabel];
        
        [_packetPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_priceBgView.mas_right).offset(-(SCREEN_WIDTH - 60)/4.0);
            make.centerY.mas_equalTo(packetTitleLabel.mas_centerY);
        }];
        
        UILabel *serviceTitleLabel = [[UILabel alloc] init];
        serviceTitleLabel.textColor = HEXACOLOR(0xffffff, 0.75);
        serviceTitleLabel.font = [UIFont systemFontOfSize:12];
        serviceTitleLabel.text = @"平台服务费";
        [_priceBgView addSubview:serviceTitleLabel];
        
        [serviceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(packetTitleLabel.mas_left);
            make.top.mas_equalTo(packetTitleLabel.mas_bottom).offset(5);
            make.bottom.mas_equalTo(_priceBgView.mas_bottom);
        }];
        
        _servicePriceLabel = [[UILabel alloc] init];
        _servicePriceLabel.textAlignment = NSTextAlignmentCenter;
        _servicePriceLabel.textColor = HEXACOLOR(0xffffff, 0.75);
        _servicePriceLabel.font = [UIFont systemFontOfSize:12];
        _servicePriceLabel.text = @"￥10";
        [_priceBgView addSubview:_servicePriceLabel];
        
        [_servicePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_packetPriceLabel.mas_left);
            make.centerY.mas_equalTo(serviceTitleLabel.mas_centerY);
        }];
    }
    return _priceBgView;
}

- (void)setModel:(ZZMemedaModel *)model
{
    [_headImgView setUser:model.mmd.from width:64 vWidth:12];
    _moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",model.mmd.total_price];
    _packetPriceLabel.text = [NSString stringWithFormat:@"%.2f",(model.mmd.total_price-model.mmd.yj_price)];
    _servicePriceLabel.text = [NSString stringWithFormat:@"%.2f",model.mmd.yj_price];
    _downBtn.hidden = NO;
    if ([model.mmd.status isEqualToString:@"wait_answer"]) {
        _statusLabel.text = @"红包待领取";
        if (![model.mmd.from.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
            _moneyLabel.text = @"回复自动领取红包";
            _statusLabel.hidden = YES;
            _downBtn.hidden = YES;
        }
        _timeLabel.text = [NSString stringWithFormat:@"%@后过期",model.mmd.expired_at_text];
    } else if ([model.mmd.status isEqualToString:@"answered"]) {
        _statusLabel.text = @"红包已领取";
        _timeLabel.text = model.mmd.answer_at_text;
    } else {
        _statusLabel.text = @"红包已过期";
        _timeLabel.text = model.mmd.expired_at_text;
    }
}

@end
