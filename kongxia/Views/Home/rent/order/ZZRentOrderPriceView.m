//
//  ZZRentOrderPriceView.m
//  zuwome
//
//  Created by qiming xiao on 2019/6/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZRentOrderPriceView.h"

@interface ZZRentOrderPriceView ()

@property (nonatomic, strong) ZZRentOrderPriceOptionView *normarlDealOPtionView;

@property (nonatomic, strong) ZZRentOrderPriceOptionView *bestDealOPtionView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) ZZUser *user;

@property (nonatomic, assign) BOOL canSelectBestDeal;

@property (nonatomic, assign) BOOL isSelectBestDeal;

@end

@implementation ZZRentOrderPriceView

- (instancetype)initWithUser:(ZZUser *)user{
    self = [super init];
    if (self) {
        _user = user;
        _isSelectBestDeal = self.canSelectBestDeal;
        [self layout];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"ZZRentOrderPriceView is Dealloced");
}

- (void)changeCurrentSelection:(RentPriceOptionType)type shouldShowProtocol:(BOOL)shouldShow isTheFirstTime:(BOOL)isTheFirstTime {
    if (type == RentPriceOptionTypeBest) {
        if (_isSelectBestDeal && shouldShow) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(viewShowBestDetailProtocols:)]) {
                [self.delegate viewShowBestDetailProtocols:self];
            }
            return;
        }
        _isSelectBestDeal = YES;
        // 选择优享
        _normarlDealOPtionView.coverView.hidden = NO;
        _bestDealOPtionView.coverView.hidden = YES;
        
        _bestDealOPtionView.frame = CGRectMake(0.0, _bestDealOPtionView.top, AdaptedWidth(210), 105);
        _normarlDealOPtionView.frame = CGRectMake(_bestDealOPtionView.right + 1, _bestDealOPtionView.top, SCREEN_WIDTH - AdaptedWidth(210) - 1, 105);
        
        _bestDealOPtionView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
        _bestDealOPtionView.prePayLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17.0];
        _bestDealOPtionView.totalLabel.font =  [UIFont systemFontOfSize:14];
        
        _normarlDealOPtionView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.0];
        _normarlDealOPtionView.prePayLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
        _normarlDealOPtionView.totalLabel.font =  [UIFont systemFontOfSize:11];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(view:isSelectBestDeal:)]) {
            [self.delegate view:self isSelectBestDeal:YES];
        }
        if (!isTheFirstTime) {
            [UIView animateWithDuration:0.3 animations:^{
                _normarlDealOPtionView.top -= 45;
                _bestDealOPtionView.top -= 45;
                _bottomView.top -= 45;
            }];
        }
        
    }
    else {
        if (!_isSelectBestDeal && shouldShow) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(view:showPriceDetails:)]) {
                [self.delegate view:self showPriceDetails:NO];
            }
            return;
        }
        
        _isSelectBestDeal = NO;
        
        if (![self canSelectBestDeal]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(view:isSelectBestDeal:)]) {
                [self.delegate view:self isSelectBestDeal:NO];
            }
            return;
        }
        
        // 选择普通
        _bestDealOPtionView.coverView.hidden = NO;
        _normarlDealOPtionView.coverView.hidden = YES;
        
        _bestDealOPtionView.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH - AdaptedWidth(210) - 1, 105);
        _normarlDealOPtionView.frame = CGRectMake(_bestDealOPtionView.right + 1, 0.0, AdaptedWidth(210), 105);
        
        _normarlDealOPtionView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
        _normarlDealOPtionView.prePayLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17.0];
        _normarlDealOPtionView.totalLabel.font =  [UIFont systemFontOfSize:14];
        
        _bestDealOPtionView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.0];
        _bestDealOPtionView.prePayLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
        _bestDealOPtionView.totalLabel.font =  [UIFont systemFontOfSize:11];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(view:isSelectBestDeal:)]) {
            [self.delegate view:self isSelectBestDeal:NO];
        }
        
        if (!isTheFirstTime) {
            [UIView animateWithDuration:0.3 animations:^{
                _normarlDealOPtionView.top += 45;
                _bestDealOPtionView.top += 45;
                _bottomView.top += 45;
            }];
        }
        else {
            _normarlDealOPtionView.top += 45;
            _bestDealOPtionView.top += 45;
            _bottomView.top += 45;
        }
    }
}

#pragma mark - response method
- (void)selectDeal:(UIGestureRecognizer *)recognizer {
    [self changeCurrentSelection:recognizer.view.tag shouldShowProtocol:YES isTheFirstTime:NO];
}

- (void)showPriceInfo:(UIGestureRecognizer *)recognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:showPriceDetails:)]) {
        [self.delegate view:self showPriceDetails:recognizer.view.tag == RentPriceOptionTypeBest];
    }
}

- (void)confirm {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirm:)]) {
        [self.delegate confirm:self];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(247, 247, 247);
    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;
    
    if (self.canSelectBestDeal) {
        [self addSubview:self.bestDealOPtionView];
        [self addSubview:self.normarlDealOPtionView];
        [self addSubview:self.bottomView];
        UIView *confirmBtnView = [[UIView alloc] init];
        confirmBtnView.backgroundColor = UIColor.whiteColor;
        [self addSubview:confirmBtnView];
        [confirmBtnView addSubview:self.confirmBtn];
        
        [self changeCurrentSelection:_isSelectBestDeal ? 2 : 1 shouldShowProtocol:NO isTheFirstTime:YES];
        _bestDealOPtionView.frame = CGRectMake(0.0, 0.0, AdaptedWidth(210), 105);
        _normarlDealOPtionView.frame = CGRectMake(_bestDealOPtionView.right + 1, 0.0, SCREEN_WIDTH - AdaptedWidth(210) - 1, 105);
        _bottomView.frame = CGRectMake(0.0, _bestDealOPtionView.bottom + 1, SCREEN_WIDTH, 44);
        
        _normarlDealOPtionView.coverView.hidden = NO;
        _bestDealOPtionView.coverView.hidden = YES;
        
        _bestDealOPtionView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
        _bestDealOPtionView.prePayLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17.0];
        _bestDealOPtionView.totalLabel.font =  [UIFont systemFontOfSize:14];
        
        _normarlDealOPtionView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.0];
        _normarlDealOPtionView.prePayLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
        _normarlDealOPtionView.totalLabel.font =  [UIFont systemFontOfSize:11];
        
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:11.0];
        if (!font) {
            font = [UIFont systemFontOfSize:11.0];
        }
        CGFloat textWidth = [NSString findWidthForText:@"私信无需赠送私信卡" havingWidth:SCREEN_WIDTH andFont:font];
        CGFloat textWidth2 = [NSString findWidthForText:@"附赠达人微信" havingWidth:SCREEN_WIDTH andFont:font];
        CGFloat textWidth3 = [NSString findWidthForText:@"免下单费" havingWidth:SCREEN_WIDTH andFont:font];
        CGFloat textWidth4 = [NSString findWidthForText:@"金牌客服" havingWidth:SCREEN_WIDTH andFont:font];
        
        CGFloat offset = (SCREEN_WIDTH - textWidth - textWidth2 - textWidth3 - textWidth4 - 30 - 16 * 4) / 3;
        
        ZZRentOrderPriceBottomBarItem *item1 = [[ZZRentOrderPriceBottomBarItem alloc] initWithTitle:@"私信无需赠送私信卡" icon:@"icSixinmianfei"];
        [_bottomView addSubview:item1];
        [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_bottomView);
            make.left.equalTo(self).offset(15);
            make.width.equalTo(@(textWidth + 1 + 15));
        }];
        
        ZZRentOrderPriceBottomBarItem *item2 = [[ZZRentOrderPriceBottomBarItem alloc] initWithTitle:@"附赠达人微信" icon:@"icFuzengweixin"];
        [_bottomView addSubview:item2];
        [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_bottomView);
            make.left.equalTo(item1.mas_right).offset(offset);
            make.width.equalTo(@(textWidth2 + 1 + 15));
        }];
        
        ZZRentOrderPriceBottomBarItem *item3 = [[ZZRentOrderPriceBottomBarItem alloc] initWithTitle:@"免下单费" icon:@"icMianxiadanfei"];
        [_bottomView addSubview:item3];
        [item3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_bottomView);
            make.left.equalTo(item2.mas_right).offset(offset);
            make.width.equalTo(@(textWidth3 + 1 + 15));
        }];
        
        ZZRentOrderPriceBottomBarItem *item4 = [[ZZRentOrderPriceBottomBarItem alloc] initWithTitle:@"金牌客服" icon:@"icJinpaikefu"];
        [_bottomView addSubview:item4];
        [item4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_bottomView);
            make.left.equalTo(item3.mas_right).offset(offset);
            make.width.equalTo(@(textWidth4 + 1 + 15));
        }];
        
        confirmBtnView.frame = CGRectMake(0.0, 150.0, SCREEN_WIDTH, 50 + ((SafeAreaBottomHeight == 0) ? 15 : SafeAreaBottomHeight));
        _confirmBtn.frame = CGRectMake(15.0, 0.0, SCREEN_WIDTH - 15.0 * 2, 50);
        
        _totalHeight = confirmBtnView.height + _bottomView.height + _bestDealOPtionView.height;
    }
    else {
        [self addSubview:self.normarlDealOPtionView];
        UIView *confirmBtnView = [[UIView alloc] init];
        confirmBtnView.backgroundColor = UIColor.whiteColor;
        [self addSubview:confirmBtnView];
        [confirmBtnView addSubview:self.confirmBtn];
        
        _normarlDealOPtionView.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, 105);
        
        confirmBtnView.frame = CGRectMake(0.0, 105, SCREEN_WIDTH, 50 + ((SafeAreaBottomHeight == 0) ? 15 : SafeAreaBottomHeight));
        _confirmBtn.frame = CGRectMake(15.0, 0.0, SCREEN_WIDTH - 15.0 * 2, 50);
        _totalHeight = confirmBtnView.height + _normarlDealOPtionView.height;
    }
}

#pragma mark - getters and setters
- (BOOL)canSelectBestDeal {
    return [ZZUserHelper shareInstance].configModel.order_wechat_enable && _user.have_wechat_no && !_user.can_see_wechat_no;
}

- (ZZRentOrderPriceOptionView *)normarlDealOPtionView {
    if (!_normarlDealOPtionView) {
        _normarlDealOPtionView = [[ZZRentOrderPriceOptionView alloc] initWithType:RentPriceOptionTypeNormal];
        _normarlDealOPtionView.tag = RentPriceOptionTypeNormal;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDeal:)];
        [_normarlDealOPtionView addGestureRecognizer:tap];
        
        UITapGestureRecognizer *priceInfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPriceInfo:)];
        [_normarlDealOPtionView.priceInfoImageView addGestureRecognizer:priceInfoTap];
    }
    return _normarlDealOPtionView;
}

- (ZZRentOrderPriceOptionView *)bestDealOPtionView {
    if (!_bestDealOPtionView) {
        _bestDealOPtionView = [[ZZRentOrderPriceOptionView alloc] initWithType:RentPriceOptionTypeBest];
        _bestDealOPtionView.tag = RentPriceOptionTypeBest;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDeal:)];
        [_bestDealOPtionView addGestureRecognizer:tap];
        
        UITapGestureRecognizer *priceInfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPriceInfo:)];
        [_bestDealOPtionView.priceInfoImageView addGestureRecognizer:priceInfoTap];
    }
    return _bestDealOPtionView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = UIColor.whiteColor;
    }
    return _bottomView;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.normalTitle = @"马上约TA";
        _confirmBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _confirmBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _confirmBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        [_confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
        _confirmBtn.layer.cornerRadius = 25.0;
    }
    return _confirmBtn;
}

- (void)setOrder:(ZZOrder *)order {
    _order = order;
    _bestDealOPtionView.order = order;
    _normarlDealOPtionView.order = order;
}
@end

@interface ZZRentOrderPriceOptionView ()

@end

@implementation ZZRentOrderPriceOptionView

- (instancetype)initWithType:(RentPriceOptionType)type {
    self = [super init];
    if (self) {
        _type = type;
        [self layout];
    }
    return self;
}

- (void)configure {
    if (_type == RentPriceOptionTypeBest) {
        _titleLabel.text = @"优享邀约";
    }
    else {
        _titleLabel.text = @"普通邀约";
    }
    
    [self calculatePrice];
}

- (void)calculatePrice {
    BOOL isMoreAccurate = NO;
    double orderPrice = [_order pureTotalPrice];
    double totalPrice = orderPrice;
    double advancePrice;
    
    if (totalPrice < 10) {
        advancePrice = totalPrice;
    }
    else {
        // 意向金采取四舍五入的形式
        advancePrice = roundf(totalPrice * 0.05);
        isMoreAccurate = YES;
    }
    
    if (_type == RentPriceOptionTypeBest) {
        totalPrice += _order.wechat_price;
        advancePrice += _order.wechat_price;
    }
    else {
        totalPrice += [_order.xdf_price doubleValue];
        advancePrice += [_order.xdf_price doubleValue];
    }

    if (isMoreAccurate) {
        _prePayLabel.text = [NSString stringWithFormat:@"预付款%.2lf",advancePrice];
    }
    else {
        _prePayLabel.text = [NSString stringWithFormat:@"预付款%.0lf",advancePrice];
    }
    
    NSString *totalPriceStr = [NSString stringWithFormat:@"总价¥%@",[ZZUtils dealAccuracyDouble:totalPrice]];
    _totalLabel.text = totalPriceStr;

}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.prePayLabel];
    [self addSubview:self.totalLabel];
    [self addSubview:self.priceInfoImageView];
    [self addSubview:self.coverView];
    
    if (_type == RentPriceOptionTypeBest) {
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15.0);
            make.top.equalTo(self).offset(10.5);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_iconImageView);
            make.left.equalTo(_iconImageView.mas_right).offset(4);
        }];
    }
    else {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10.5);
            make.right.equalTo(self).offset(-15);
        }];
    }
    
    [_prePayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(42);
    }];
    
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-10);
        make.top.equalTo(_prePayLabel.mas_bottom).offset(7);
    }];
    
    [_priceInfoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_totalLabel);
        make.left.equalTo(_totalLabel.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - getters and setters
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.hidden = YES;
        _coverView.backgroundColor = RGBACOLOR(255, 255, 255, 0.6);
    }
    return _coverView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"icYxyy"];
        _iconImageView.userInteractionEnabled = YES;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _titleLabel;
}

- (UILabel *)prePayLabel {
    if (!_prePayLabel) {
        _prePayLabel = [[UILabel alloc] init];
        _prePayLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17.0];
        _prePayLabel.textColor = RGBCOLOR(63, 58, 58);
        _prePayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _prePayLabel;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = [UIFont systemFontOfSize:14];
        _totalLabel.textColor = kGrayTextColor;//RGBCOLOR(63, 58, 58);
        _totalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalLabel;
}

- (UIImageView *)priceInfoImageView {
    if (!_priceInfoImageView) {
        _priceInfoImageView = [[UIImageView alloc] init];
        _priceInfoImageView.image = [UIImage imageNamed:@"icHelpYyCopy"];
        _priceInfoImageView.userInteractionEnabled = YES;
        
    }
    return _priceInfoImageView;
}

- (void)setOrder:(ZZOrder *)order {
    _order = order;
    [self configure];
}

@end

@interface ZZRentOrderPriceBottomBarItem ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZZRentOrderPriceBottomBarItem

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon {
    self = [super init];
    if (self) {
        [self layout];
        
        _titleLabel.text = title;
        _iconImageView.image = [UIImage imageNamed:icon];
    }
    return self;
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_iconImageView.mas_right).offset(1);
    }];
    
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11.0];
        _titleLabel.textColor = RGBCOLOR(102, 102, 102);
    }
    return _titleLabel;
}

@end
