//
//  ZZKTVTaskPrePayView.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/9.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVTaskPrePayView.h"
#import "ZZKTVConfig.h"


@interface ZZKTVTaskPrePayView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIView *seperateLine;

@property (nonatomic, strong) UIImageView *mebiIconImageView;

@property (nonatomic, strong) UILabel *mebiLabel;

@property (nonatomic, strong) UILabel *needToPayLabel;

@property (nonatomic, strong) UIImageView *giftIconImageView;

@property (nonatomic, strong) UIImageView *giftCountsImageView;

@property (nonatomic, strong) UILabel *giftCountsLabel;

@end

@implementation ZZKTVTaskPrePayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - private method
- (void)configureData {
    NSInteger needToPay = _taskModel.gift.mcoin * _taskModel.gift_count;
    _needToPayLabel.text = [NSString stringWithFormat:@"支付%ld么币",needToPay];
    
    [_giftIconImageView sd_setImageWithURL:[NSURL URLWithString:_taskModel.gift.icon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    _giftCountsLabel.text = [NSString stringWithFormat:@"%ld", _taskModel.gift_count];
}

- (void)updateMebi {
    // 更新当前么币的数量
    NSUInteger leftMcoin = [[ZZUserHelper shareInstance].loginer.mcoin integerValue];
    _mebiLabel.text = [NSString stringWithFormat:@"%ld", leftMcoin];
}

- (void)createTask {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewCreateTask:)]) {
        [self.delegate viewCreateTask:self];
    }
    [self hide];
}

#pragma mark - public Method
- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.76;
        _contentView.top = self.height - _contentView.height;
    } completion:^(BOOL finished) {
        _bgView.userInteractionEnabled = YES;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.0;
        _contentView.top = self.height;
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_contentView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


#pragma mark - response method
- (void)hideView {
    [self hide];
}

- (void)payAction {
    NSInteger totalMcoin = [[ZZUserHelper shareInstance].loginer.mcoin integerValue];
    NSInteger needToPay = _taskModel.gift.mcoin * _taskModel.gift_count;
    
    if (totalMcoin < needToPay) {
        [self showRechargeView:_taskModel.gift.mcoin * _taskModel.gift_count];
    }
    else {
        [self createTask];
    }
}


#pragma mark - Layout
- (void)layout {
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.mebiIconImageView];
    [self.contentView addSubview:self.mebiLabel];
    [self.contentView addSubview:self.needToPayLabel];
    [self.contentView addSubview:self.seperateLine];
    [self.contentView addSubview:self.giftIconImageView];
    [self.contentView addSubview:self.giftCountsImageView];
    [self.contentView addSubview:self.giftCountsLabel];
    [self.contentView addSubview:self.confirmBtn];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10.0);
        make.left.right.equalTo(self.contentView);
    }];
    
    [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10.0);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    [_mebiIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_seperateLine.mas_bottom).offset(11.5);
        make.left.equalTo(_contentView).offset(15.0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [_mebiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_mebiIconImageView);
        make.left.equalTo(_mebiIconImageView.mas_right).offset(8);
    }];
    
    [_needToPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_mebiIconImageView);
        make.right.equalTo(_contentView).offset(-10.5);
    }];
    
    [_giftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mebiIconImageView.mas_bottom).offset(58);
        make.left.equalTo(_contentView).offset(SCALE_SET(110.5));
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [_giftCountsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_giftIconImageView);
        make.left.equalTo(_giftIconImageView.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [_giftCountsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_giftCountsImageView);
        make.left.equalTo(_giftCountsImageView.mas_right).offset(8);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentView);
        make.left.equalTo(self.contentView).offset(15.0);
        make.right.equalTo(self.contentView).offset(-15.0);
        make.height.equalTo(@50.0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.contentView.mas_safeAreaLayoutGuideBottom).offset(-15.0);
        } else {
            make.bottom.equalTo(self.contentView).offset(-15.0);
        }
    }];

}

- (void)showRechargeView:(NSInteger)totalCounts {
    ZZWeiChatEvaluationModel *model = [[ZZWeiChatEvaluationModel alloc]init];
    model.type = PaymentTypeKTVGift;
    model.source = SourceKTV;
    model.mcoinForItem = totalCounts;
    
    WeakSelf
    [[ZZPaymentManager shared] buyItemWithPayItem:model in:_parentVC buyComplete:^(BOOL isSuccess, NSString * _Nonnull payType) {
    } rechargeComplete:^(BOOL isSuccess) {
        [ZZUser loadUser:[ZZUserHelper shareInstance].loginerId param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            }
            else {
                ZZUser *user = [ZZUser yy_modelWithJSON:data];
                [[ZZUserHelper shareInstance] saveLoginer:user postNotif:NO];
                
                [ZZUserHelper shareInstance].consumptionMebi = 0;
                [weakSelf updateMebi];
                
                // 假如是直接点击礼物的,在充值之后要直接点击发送
                [weakSelf createTask];;
            }
        }];
    }];
}

#pragma mark - getters and setters
- (void)setTaskModel:(ZZKTVModel *)taskModel {
    _taskModel = taskModel;
    [self configureData];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [_bgView addGestureRecognizer:tap];
        _bgView.userInteractionEnabled = NO;
    }
    return _bgView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.bottom, self.width, 341 + SafeAreaBottomHeight)];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"点唱Party派送礼物";
        _titleLabel.font = ADaptedFontMediumSize(15.0);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _titleLabel;
}

- (UIImageView *)mebiIconImageView {
    if (!_mebiIconImageView) {
        _mebiIconImageView = [[UIImageView alloc] init];
        _mebiIconImageView.image = [UIImage imageNamed:@"icMebi"];
    }
    return _mebiIconImageView;
}

- (UILabel *)mebiLabel {
    if (!_mebiLabel) {
        _mebiLabel = [[UILabel alloc] init];
        _mebiLabel.font = ADaptedFontMediumSize(17);
        _mebiLabel.textColor = RGBCOLOR(63, 58, 58);
        _mebiLabel.textAlignment = NSTextAlignmentRight;
        NSUInteger leftMcoin = [[ZZUserHelper shareInstance].loginer.mcoin integerValue];
        _mebiLabel.text = [NSString stringWithFormat:@"么币余额：%ld", leftMcoin];
    }
    return _mebiLabel;
}

- (UILabel *)needToPayLabel {
    if (!_needToPayLabel) {
        _needToPayLabel = [[UILabel alloc] init];
        _needToPayLabel.font = ADaptedFontMediumSize(15);
        _needToPayLabel.textColor = RGBCOLOR(173, 173, 177);
        _needToPayLabel.textAlignment = NSTextAlignmentRight;
    }
    return _needToPayLabel;
}

- (UIView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = RGBCOLOR(229, 229, 229);
    }
    return _seperateLine;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.normalTitle = @"确认支付";
        _confirmBtn.normalTitleColor = UIColor.blackColor;
        _confirmBtn.titleLabel.font = ADaptedFontSCBoldSize(15);
        _confirmBtn.backgroundColor = kGoldenRod;
        _confirmBtn.layer.cornerRadius = 25;
        [_confirmBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UILabel *)giftCountsLabel {
    if (!_giftCountsLabel) {
        _giftCountsLabel = [[UILabel alloc] init];
        _giftCountsLabel.text = @"16";
        _giftCountsLabel.textColor = RGBCOLOR(153, 153, 153);
        _giftCountsLabel.font = ADaptedFontBoldSize(24);
        _giftCountsLabel.textAlignment = NSTextAlignmentRight;
    }
    return _giftCountsLabel;
}

- (UIImageView *)giftCountsImageView {
    if (!_giftCountsImageView) {
        _giftCountsImageView = [[UIImageView alloc] init];
        _giftCountsImageView.image = [UIImage imageNamed:@"icShenghao"];
    }
    return _giftCountsImageView;
}

- (UIImageView *)giftIconImageView {
    if (!_giftIconImageView) {
        _giftIconImageView = [[UIImageView alloc] init];
    }
    return _giftIconImageView;
}

@end
