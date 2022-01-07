//
//  ZZInfoToastView.m
//  zuwome
//
//  Created by qiming xiao on 2019/2/14.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostTaskRulesToastView.h"

@interface ZZPostTaskRulesToastView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) ZZPostTaskRulesView *toastView;

@end

@implementation ZZPostTaskRulesToastView

+ (instancetype)show {
    ZZPostTaskRulesToastView *infoToastView = [[ZZPostTaskRulesToastView alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:infoToastView];
    [infoToastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    [infoToastView show];
    return infoToastView;
}

+ (instancetype)showWithRulesType:(RulesType)rulesType {
    ZZPostTaskRulesToastView *infoToastView = [[ZZPostTaskRulesToastView alloc] initWithRuleType:rulesType];
    [[UIApplication sharedApplication].keyWindow addSubview:infoToastView];
    [infoToastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    [infoToastView show];
    return infoToastView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _rulesType = RulesTypePostTask;
        [self layoutUI];
    }
    return self;
}

- (instancetype)initWithRuleType:(RulesType)rulesType {
    self = [super init];
    if (self) {
        _rulesType = rulesType;
        [self layoutUI];
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.5;
        _toastView.alpha = 1.0;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0;
        _toastView.alpha = 0;
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_toastView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)closeAction {
    [self hide];
}

- (void)action {
    [self hide];
}

#pragma mark - UI
- (void)layoutUI {
    [self addSubview:self.bgView];
    [self addSubview:self.toastView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(@312);
    }];
}

#pragma mark - Setter&Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (ZZPostTaskRulesView *)toastView {
    if (!_toastView) {
        _toastView = [[ZZPostTaskRulesView alloc] initWithRulesType:_rulesType];
        _toastView.alpha = 0.0;
        [_toastView.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [_toastView.actionButton addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toastView;
}

@end


@interface ZZPostTaskRulesView ()

@end

@implementation ZZPostTaskRulesView

- (instancetype)initWithRulesType:(RulesType)rulesType {
    self = [super init];
    if (self) {
        _rulesType = rulesType;
        [self layout];
    }
    return self;
}

- (void)configData {
    
}

#pragma mark - UI
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 6;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.actionButton];
    [self addSubview:self.closeButton];
    
    __block UIView *bottomView = nil;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.right.equalTo(self).offset(-15.0);
        make.top.equalTo(self).offset(20.0);
    }];
    bottomView = _titleLabel;
    
    [self.datasArray enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.image = [UIImage imageNamed:obj[@"icon"]];
        iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:iconImageView];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:14.0];
        contentLabel.textColor = RGBCOLOR(102, 102, 102);
        contentLabel.text = obj[@"content"];
        [self addSubview:contentLabel];
        
        CGSize imageSize = CGSizeMake(21.0, 21.0);
        if (_rulesType == RulesTypePostTask) {
            if (idx == 0) {
                imageSize = CGSizeMake(19.0, 21.0);
            }
            else if (idx == 1) {
                imageSize = CGSizeMake(19.0, 19.0);
            }
            else if (idx == 2) {
                imageSize = CGSizeMake(20.0, 20.0);
            }
        }
        else {
            imageSize = CGSizeMake(20.0, 20.0);
        }
        
        if (idx == _datasArray.count - 1 && _rulesType == RulesTypeAddSkill) {
            iconImageView.hidden = YES;
            contentLabel.textColor = RGBCOLOR(171, 171, 171);
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bottomView.mas_bottom).offset(idx == 0 ? 24.0 : 14.0);
                make.centerX.equalTo(self);
                make.left.equalTo(self).offset(41);
                make.right.equalTo(self).offset(-41);
            }];
        }
        else {
            [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bottomView.mas_bottom).offset(idx == 0 ? (_rulesType == RulesTypePostActivity ? 31.0 : 24.0) : (_rulesType == RulesTypePostActivity ? 21.0 : 14.0));
                make.left.equalTo(self).offset(29.5);
                make.size.mas_equalTo(imageSize);
            }];
            
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(iconImageView);
                make.left.equalTo(iconImageView.mas_right).offset(8.0);
                make.right.equalTo(self).offset(-30.5);
            }];
        }
        
        if (_rulesType == RulesTypeAddSkill) {
            UIImageView *lineImageView = [[UIImageView alloc] init];
            lineImageView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:lineImageView];
            
            CGFloat lineHeight = 0;
            NSString *icon = @"";
            if (idx == 0) {
                lineHeight = 26.5;
                icon = @"path43";
            }
            else if (idx == 1) {
                lineHeight = 8;
                icon = @"path46";
            }
            else if (idx == 2) {
                lineHeight = 46.5;
                icon = @"path49";
            }
            else if (idx == 3) {
                lineHeight = 55;
                icon = @"path50";
            }
            [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(iconImageView.mas_bottom);
                make.centerX.equalTo(iconImageView);
                make.width.equalTo(@(1));
                make.height.equalTo(@(lineHeight));
            }];
            lineImageView.image = [UIImage imageNamed:icon];
        }
        
        bottomView = contentLabel;
    }];
    
    [_actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        if (_rulesType == RulesTypePostActivity) {
            make.top.equalTo(bottomView.mas_bottom).offset(54.0);
        }
        else {
            make.top.equalTo(bottomView.mas_bottom).offset(25.0);
        }
        make.height.equalTo(@(44.5));
        make.bottom.equalTo(self).offset(-15.0);
        make.left.equalTo(self).offset(14.0);
        make.right.equalTo(self).offset(-14.0);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15.0);
        make.right.equalTo(self).offset(-15.0);
        make.size.mas_equalTo(CGSizeMake(22.0, 22.0));
    }];
}

#pragma mark - Setter&Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"通告发布规则";
        _titleLabel.textColor = RGBCOLOR(244, 203, 7);
        
        if (_rulesType == RulesTypePostTask) {
            _titleLabel.text = @"通告发布规则";
        }
        else if (_rulesType == RulesTypeAddSkill) {
            _titleLabel.text = @"什么是平台担保支付？";
        }
        else if (_rulesType == RulesTypePostActivity) {
            _titleLabel.text = @"达人发布活动规则";
        }
    }
    return _titleLabel;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [[UIButton alloc] init];
        _actionButton.backgroundColor = RGBCOLOR(244, 203, 7);
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_actionButton setTitleColor:RGBCOLOR(63, 58, 58) forState:UIControlStateNormal];
        [_actionButton setTitle:@"知道了" forState:UIControlStateNormal];
        _actionButton.layer.cornerRadius = 3.0;
    }
    return _actionButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"icGbTc"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (NSArray<NSDictionary<NSString *, NSString *> *> *)datasArray {
    if (!_datasArray) {
        if (_rulesType == RulesTypePostTask) {
            NSDictionary *dic1 = @{
                                   @"icon": @"icDidianTc",
                                   @"content": @"通告地点必须选择公众场合",
                                   };
            
            NSDictionary *dic2 = @{
                                   @"icon": @"icJineYaoyueCopy3",
                                   @"content": @"发布通告需支付发布服务费，发布服务费为通告金额*30%，发布成功30分钟后且无人报名的情况下，您取消发布或通告自动过期后，发布服务费将全额退回",
                                   };
            
            NSDictionary *dic3 = @{
                                   @"icon": @"icJineYaoyueCopy3",
                                   @"content": @"发布后30分钟以内取消、结束报名，或达人报名成功后取消、结束报名，通告服务费不可退还",
                                   };
            NSDictionary *dic4 = @{
                                   @"icon": @"icTupianTc",
                                   @"content": @"上传包含联系方式或低俗敏感图片，或违反平台其他规则，通告将会被屏蔽，您也将会被处罚",
                                   };
            _datasArray = @[dic1, dic2, dic3, dic4];
        }
        else if (_rulesType == RulesTypeAddSkill) {
            NSDictionary *dic1 = @{
                                   @"icon": @"icJineYaoyueCopy4",
                                   @"content": @"用户点击\"马上预约\"付款后，资金在平台监管中，保证资金安全",
                                   };
            
            NSDictionary *dic2 = @{
                                   @"icon": @"icYaoyueXx",
                                   @"content": @"用户和达人线下邀约见面中",
                                   };
            
            NSDictionary *dic3 = @{
                                   @"icon": @"copy10",
                                   @"content": @"如遇异常情况，及时举报，平台将能及时处理款项，保障用户、达人各自的合法权益",
                                   };
            NSDictionary *dic4 = @{
                                   @"icon": @"icXzJbwx",
                                   @"content": @"见面完成后，用户点击“已完成”，款项才会由平台转给达人；或达人点击“已到达”，48小时后款项自动转入达人账户",
                                   };
            
            NSDictionary *dic5 = @{
                                   @"icon": @"icXzJbwx",
                                   @"content": @"请保证在平台内进行邀约，否则空虾将无法保障您的资金和权益",
                                   };
            _datasArray = @[dic1, dic2, dic3, dic4, dic5];
        }
        else if (_rulesType == RulesTypePostActivity) {
            NSDictionary *dic1 = @{
                                   @"icon": @"icDidianTc",
                                   @"content": @"活动地点，请选择公众场合",
                                   };
            
            NSDictionary *dic2 = @{
                                   @"icon": @"icTupianTc",
                                   @"content": @"上传包含联系方式或低俗敏感图片，邀约将会被屏蔽，严重者将会被处罚",
                                   };
            
            NSDictionary *dic3 = @{
                                   @"icon": @"icTupianTc",
                                   @"content": @"当前活动为免费发布，发布者无须向参与者支付邀约金。利用活动，实施违法行为的，将永久封号。视情节严重，空虾将配合相关用户向公安机关提供违法、犯罪人的相关信息，并配合抓捕等",
                                   };
            
            _datasArray = @[dic1, dic2, dic3, ];
        }
        
    }
    return _datasArray;
}

@end
