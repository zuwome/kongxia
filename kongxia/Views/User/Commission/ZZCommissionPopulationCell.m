//
//  ZZCommissionPopulationCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/11.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCommissionPopulationCell.h"

#import "ZZCommissionModel.h"

@interface ZZCommissionPopulationCell ()

@property (nonatomic, strong) UIView *contextView;

@property (nonatomic, strong) UIView *stepsView;

@property (nonatomic, strong) UIImageView *stepsImageView;

@property (nonatomic, strong) UIView *rulesView;

@property (nonatomic, strong) UIButton *rulesBtn;

@property (nonatomic, copy) NSArray<UIImageView *> *stepsIconImageViewArr;

@property (nonatomic, copy) NSArray<UILabel *> *stepsTitleLabelArr;

@property (nonatomic, strong) CAShapeLayer *stepsLayer;

@property (nonatomic, strong) CAShapeLayer *rulesLayer;

@end


@implementation ZZCommissionPopulationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    
    [_stepsTitleLabelArr enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < _commissionModel.tip_b.btn_arr.count) {
            obj.text = _commissionModel.tip_b.btn_arr[idx];
        }
    }];
    
    [self createRulesView];
    
    [self layoutIfNeeded];
    
    if (!_commissionModel) {
        return;
    }
    
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

          _stepsLayer = [CAShapeLayer layer];
          _stepsLayer.strokeColor = RGBCOLOR(242, 132, 77).CGColor;
          _stepsLayer.fillColor = nil;
          
          _stepsLayer.path = [UIBezierPath bezierPathWithRoundedRect:_stepsView.bounds cornerRadius:10.0].CGPath;
          _stepsLayer.frame = _stepsView.bounds;
          _stepsLayer.lineWidth = 1.5;
          _stepsLayer.lineCap = @"square";
          _stepsLayer.lineDashPattern = @[@6, @4];
          _stepsLayer.cornerRadius = 5;
          [_stepsView.layer addSublayer:_stepsLayer];
          
          _rulesLayer = [CAShapeLayer layer];
          _rulesLayer.strokeColor = RGBCOLOR(242, 132, 77).CGColor;
          _rulesLayer.fillColor = nil;
          
          _rulesLayer.path = [UIBezierPath bezierPathWithRoundedRect:_rulesView.bounds cornerRadius:10.0].CGPath;
          _rulesLayer.frame = _rulesView.bounds;
          _rulesLayer.lineWidth = 1.5;
          _rulesLayer.lineCap = @"square";
          _rulesLayer.lineDashPattern = @[@6, @4];
          _rulesLayer.cornerRadius = 5;
          [_rulesView.layer addSublayer:_rulesLayer];
   });
}


#pragma mark - response method
- (void)showRules {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellshowInvitedView:)]) {
        [self.delegate cellshowInvitedView:self];
    }
}


#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.contextView];
    [_contextView addSubview:self.stepsView];
    [_contextView addSubview:self.stepsImageView];
    
    [_contextView addSubview:self.rulesView];
    [_rulesView addSubview:self.rulesBtn];
    
    [_contextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
    }];
    
    [_stepsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contextView).offset(9);
        make.top.equalTo(_contextView).offset(9);
        make.right.equalTo(_contextView).offset(-9);
    }];
    
    [_stepsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_stepsView);
        make.size.mas_equalTo(CGSizeMake(156, 35));
    }];
    
    [_rulesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_stepsView);
        make.top.equalTo(_stepsView.mas_bottom).offset(-2);
        make.right.equalTo(_stepsView);
        make.bottom.equalTo(_contextView).offset(-9);
    }];
    
    [self createStepsLayout];
}

- (void)createStepsLayout {
    NSMutableArray *iconArr = @[].mutableCopy;
    NSMutableArray *labelArr = @[].mutableCopy;
    
    CGFloat buttonOffset = (SCREEN_WIDTH - 64 * 2 - 39 * 3) / 2;
    
    for (int i = 0; i < 3 ; i++) {
        NSString *icon = nil;
        NSString *title = nil;
        if (i == 0) {
            icon = @"icTupian_com";
            title = @"发送邀请图或链接给好友";
        }
        else if (i == 1) {
            icon = @"icLianjie";
            title = @"好友通过扫码或链接下载并注册空虾";
        }
        else if (i == 2) {
            icon = @"icFenhong";
            title = @"好友消费或收入你都有高至10%的分红";
        }
        
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.image = [UIImage imageNamed:icon];
        [_stepsView addSubview:imageview];
        
        UILabel *titlelabel = [[UILabel alloc] init];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        titlelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        titlelabel.textColor = RGBCOLOR(102, 102, 102);
        titlelabel.text = title;
        titlelabel.numberOfLines = 0;
        [_stepsView addSubview:titlelabel];
        
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_stepsView).offset(40 + (39 + buttonOffset) * (i % 3));
            make.top.equalTo(_stepsView).offset(59);
            make.size.mas_equalTo(CGSizeMake(39, 39));
        }];
        
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageview);
            make.top.equalTo(imageview.mas_bottom).offset(3);
            make.width.equalTo(@80);
            make.bottom.equalTo(_stepsView).offset(-24);
        }];
        
        [iconArr addObject:imageview];
        [labelArr addObject:titlelabel];
        
        UIImageView *navigator = [[UIImageView alloc] init];
        navigator.image = [UIImage imageNamed:@"icJiantou"];
        [_stepsView addSubview:navigator];
        if (i == 0 || i == 1) {
            [navigator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(imageview);
                make.left.equalTo(imageview.mas_right).offset(buttonOffset * 0.5 - 25 * 0.5);
                make.size.mas_equalTo(CGSizeMake(25, 7));
            }];
        }
    }
    
    _stepsIconImageViewArr = iconArr.copy;
    _stepsTitleLabelArr = labelArr.copy;
}

- (void)createRulesView {
    __block UIView *view = nil;
    [_commissionModel.tip_b.end_tip_arr enumerateObjectsUsingBlock:^(NSString * _Nonnull rule, NSUInteger idx, BOOL * _Nonnull stop) {

        UILabel *ruleLabel = [self createRulesLabel];
        ruleLabel.text = [NSString stringWithFormat:@"• %@", rule];
        [_rulesView addSubview:ruleLabel];

        [ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_rulesView).offset(19.0);
            make.right.equalTo(_rulesView).offset(-15.0);
            if (view) {
                make.top.equalTo(view.mas_bottom).offset(2);
            }
            else {
                make.top.equalTo(_rulesView).offset(15.5);
            }
        }];

        view = ruleLabel;
    }];

    if (view) {
        [_rulesBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_bottom).offset(16);
            make.centerX.equalTo(_rulesView);
            make.bottom.equalTo(_rulesView).offset(-16);
            make.height.equalTo(@20);
        }];
        
        UIImageView *icon1 = [[UIImageView alloc] init];
        icon1.image = [UIImage imageNamed:@"icGengduo_com"];
        [_rulesView addSubview:icon1];
        
        UIImageView *icon2 = [[UIImageView alloc] init];
        icon2.image = [UIImage imageNamed:@"icGengduo_com"];
        [_rulesView addSubview:icon2];
        
        [icon1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_rulesBtn.mas_right).offset(6);
            make.centerY.equalTo(_rulesBtn);
            make.size.mas_equalTo(CGSizeMake(5, 12));
        }];
        
        [icon2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon1.mas_right).offset(1);
            make.centerY.equalTo(_rulesBtn);
            make.size.mas_equalTo(CGSizeMake(5, 12));
        }];
    }
}

- (UILabel *)createRulesLabel {
    UILabel *ruleLabel = [[UILabel alloc] init];
    ruleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13.0];
    ruleLabel.numberOfLines = 0;
    ruleLabel.textColor = RGBCOLOR(102, 102, 102);
    return ruleLabel;
}

#pragma mark - getters and setters
- (void)setCommissionModel:(ZZCommissionModel *)commissionModel {
    _commissionModel = commissionModel;
    [self configureData];
}

- (UIView *)contextView {
    if (!_contextView) {
        _contextView = [[UIView alloc] init];
        _contextView.backgroundColor = UIColor.whiteColor;
        _contextView.layer.cornerRadius = 10.0;
    }
    return _contextView;
}

- (UIView *)stepsView {
    if (!_stepsView) {
        _stepsView = [[UIView alloc] init];
        _stepsView.backgroundColor = UIColor.whiteColor;
        _stepsView.layer.cornerRadius = 5.0;
    }
    return _stepsView;
}

- (UIView *)rulesView {
    if (!_rulesView) {
        _rulesView = [[UIView alloc] init];
        _rulesView.backgroundColor = UIColor.whiteColor;
    }
    return _rulesView;
}

- (UIImageView *)stepsImageView {
    if (!_stepsImageView) {
        _stepsImageView = [[UIImageView alloc] init];
        _stepsImageView.image = [UIImage imageNamed:@"10"];
    }
    return _stepsImageView;
}

- (UIButton *)rulesBtn {
    if (!_rulesBtn) {
        _rulesBtn = [[UIButton alloc] init];
        _rulesBtn.normalTitle = @"查看分红详细规则";
        _rulesBtn.normalTitleColor = RGBCOLOR(74, 144, 226);
        _rulesBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [_rulesBtn addTarget:self action:@selector(showRules) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rulesBtn;
}

@end
