//
//  ZZIntegtalTopCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/14.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZIntegtalTopCell.h"
#import "ZZCircularView.h"
#import "ZZSignInView.h"
#import "ZZIntegralHelper.h"
@interface ZZIntegtalTopCell()

/**
 黑色的背景
 */
@property (nonatomic,strong) UIView *bgView;

/**
 累计的积分图标
 */
@property (nonatomic,strong) UIImageView *integralImage;

/**
 卡片的imageView
 */
@property (nonatomic,strong) UIImageView *cardBgImageView;

/**
 规则说明
 */
@property (nonatomic,strong) UIButton *ruleDescriptionButton;

/**
签到的积分梯度背景展示
 */
@property (nonatomic,strong) UIView *ruleBgView;

/**
 累计的签到积分
 */
@property (nonatomic,strong ) UILabel *signInIntegralLab;


/**
签到的view
 */
@property (nonatomic,strong ) ZZSignInView *signInView;

/**
 签到的渐变色线条
 */
@property (nonatomic,strong) UIView *signLineLab;

/**
 签到的正常白色线条
 */
@property (nonatomic,strong) UIView *signNormalLineView;

/**
 飞机
 */
@property (nonatomic,strong ) UIImageView *planeImageView;




@end
@implementation ZZIntegtalTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
        
    }
    return self;
}

/**
设置布局
 */
- (void)setUI {
    
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.cardBgImageView];
    [self.bgView addSubview:self.integralImage];
    [self.bgView addSubview:self.ruleBgView];
    [self.bgView addSubview:self.integralLab];
    [self.bgView addSubview:self.ruleDescriptionButton];
    [self.bgView addSubview:self.signInIntegralLab];
    [self.bgView addSubview:self.signInView];
    [self.bgView addSubview:self.signLineLab];
    
    [self.bgView addSubview:self.signNormalLineView];

    [self.bgView addSubview:self.planeImageView];

    [self setUpTheConstraints];
    
}


/**
 根据model 更新对应的数据
 */
- (void)setModel:(ZZIntegralModel *)model {
    if (_model != model ) {
        _model = model;
        //累计的签到积分
        int  signInIntegral = 0;
        //点亮签到积分
        signInIntegral =    [self  lightUpSignInLabWithSignInIntegral:signInIntegral withDay:[self.model.sign_task.day intValue]];
        
        //总积分
        self.integralLab.text = [NSString stringWithFormat:@"%ld",(long)self.model.integral];
        self.signInView.model = model;
        //签到的说明
        [self setCustomSignDay:[NSString stringWithFormat:@"%@",self.model.sign_task.day] signInIntegral:[NSString stringWithFormat:@"%d",signInIntegral]];
        [self update];
    }
}



/**
 根据初始状态更新
 */
- (void)update {
    
    if ([self.model.sign_task.day intValue]<1) {
        return;
    }
    for (int i = 0; i<[self.model.sign_task.day intValue]; i++) {
        UIView *view  = [self.bgView viewWithTag:i+400];
        view.backgroundColor = RGBCOLOR(244, 203, 7);
    }
    int   signInDayNumber = [self.model.sign_task.day intValue];
    
    float width = SCREEN_WIDTH -30;
    float spaceWidth = (width -35*7)/6.0f;
    [self.bgView setNeedsLayout];
    [self.signLineLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(11+(signInDayNumber -1)*(35+spaceWidth)));
    }];
 
    [self.signNormalLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardBgImageView.mas_left).offset(11+(signInDayNumber -1)*(35+spaceWidth));
    }];
    self.planeImageView.hidden = NO;
    [self.planeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cardBgImageView.mas_left).offset(11+(signInDayNumber -1)*(35+spaceWidth));
    }];
    [self.bgView layoutIfNeeded];
    for (CAGradientLayer *layer in _signLineLab.layer.sublayers) {
        if ([layer.type isEqualToString:@"signType"]) {
            [layer removeFromSuperlayer];
        }
    }
     [_signLineLab.layer addSublayer:[ZZUtils setGradualChangingColor:_signLineLab fromColor:RGBACOLOR(255, 236, 3,0) toColor:RGBACOLOR(248, 126, 13,1) endPoint:CGPointMake(1, 1) locations:@[@0,@1] type:@"signType"]];
}

#pragma mark - 签到请求网络接口

- (void)requestSign {
    [MobClick event:Event_click_myIntegral_sign_in];

//       [self flipAnimation];
    [ZZIntegralHelper signInSuccess:^{
        [self flipAnimation];
    } failure:^(ZZError *error) {
        [ZZHUD showTastInfoErrorWithString:error.message];
    }];
    
}

#pragma  mark  -   翻转  - 飞机飞

/**
 2 秒翻转
 */
- (void)flipAnimation {
    //开启翻转动画

    self.signInView.userInteractionEnabled = NO;
    [self.signInView flipAnimation];
    int   signInDayNumber = [self.model.sign_task.day intValue];
    //更新总积分
    self.model.integral += [self.model.sign_task.score_list[signInDayNumber] integerValue];
    self.integralLab.text = [NSString stringWithFormat:@"%ld",(long)self.model.integral];
    if (self.signInBlock) {
        self.signInBlock(self.model);
    }

    float width = SCREEN_WIDTH -30;
    float spaceWidth = (width -35*7)/6.0f;
    //飞机飞
    self.planeImageView.hidden = NO;
    for (int i = 0; i<signInDayNumber; i++) {
        UIView *view  = [self.bgView viewWithTag:i+400];
        view.backgroundColor = RGBCOLOR(244, 203, 7);
    }
    [self.bgView setNeedsLayout];
    [self.signLineLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(11+signInDayNumber*(35+spaceWidth)));
    }];
    [self.bgView layoutIfNeeded];
    int  signInIntegral = 0;
    signInIntegral = [self  lightUpSignInLabWithSignInIntegral:signInIntegral withDay:signInDayNumber+1];
    //签到的说明
    [self setCustomSignDay:[NSString stringWithFormat:@"%d",signInDayNumber+1] signInIntegral:[NSString stringWithFormat:@"%d",signInIntegral]];
    for (CAGradientLayer *layer in _signLineLab.layer.sublayers) {
        if ([layer.type isEqualToString:@"signType"]) {
            [layer removeFromSuperlayer];
        }
    }
    [UIView animateWithDuration:2 animations:^{
        
        [self.bgView setNeedsLayout];
        [self.signNormalLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cardBgImageView.mas_left).offset(11+signInDayNumber*(35+spaceWidth));
        }];
        [self.planeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.cardBgImageView.mas_left).offset(11+signInDayNumber*(35+spaceWidth));
        }];
        CAGradientLayer *layer = [ZZUtils setGradualChangingColor:_signLineLab fromColor:RGBACOLOR(255, 236, 3,0) toColor:RGBACOLOR(248, 126, 13,1) endPoint:CGPointMake(1, 1) locations:@[@0,@1] type:@"signType"];
        [_signLineLab.layer addSublayer:layer];

        [self.bgView layoutIfNeeded];
    } completion:nil];
  
}


#pragma  mark - 懒加载

- (UIImageView *)integralImage {
    if (!_integralImage) {
        _integralImage = [[UIImageView alloc]init];
        _integralImage.image = [UIImage imageNamed:@"icJifenCard"];
        _integralImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _integralImage;
}

- (UIView *)ruleBgView {
    if (!_ruleBgView) {
        _ruleBgView = [[UIView alloc]init];
        _ruleBgView.backgroundColor = RGBCOLOR(59, 58, 58);
    }
    return _ruleBgView;
}

/**
 卡片背景imaeview
 */
- (UIImageView *)cardBgImageView {
    if (!_cardBgImageView) {
        _cardBgImageView = [[UIImageView alloc]init];
        _cardBgImageView.image = [UIImage imageNamed:@"IntegtalTopCard"];
        _cardBgImageView.contentMode = UIViewContentModeScaleAspectFill ;
    }
    return _cardBgImageView ;
}


/**
 总的积分
 */
- (UILabel *)integralLab {
    if (!_integralLab) {
        _integralLab = [[UILabel alloc]init];
        _integralLab.textColor = RGBCOLOR(134, 120, 72);
        _integralLab.textAlignment = NSTextAlignmentCenter;
        _integralLab.font =  [UIFont fontWithName:@"Futura-Medium" size:15];

    }
    return _integralLab;
}


/**
 规则说明
 */
- (UIButton *)ruleDescriptionButton {
    if (!_ruleDescriptionButton) {
        _ruleDescriptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ruleDescriptionButton setTitle:@"规则说明" forState:UIControlStateNormal];
        [_ruleDescriptionButton setTitleColor:RGBCOLOR(99, 79, 35) forState:UIControlStateNormal];
        [_ruleDescriptionButton setImage:[UIImage imageNamed:@"icPrivilegeDetails"] forState:UIControlStateNormal];
        _ruleDescriptionButton.titleLabel.font = CustomFont(12);
        [_ruleDescriptionButton addTarget:self action:@selector(ruleDescriptionButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _ruleDescriptionButton.imageEdgeInsets = UIEdgeInsetsMake(0, 65, 0, -_ruleDescriptionButton.titleLabel.width - 2.5);
        _ruleDescriptionButton.titleEdgeInsets = UIEdgeInsetsMake(0, -_ruleDescriptionButton.currentImage.size.width, 0, _ruleDescriptionButton.currentImage.size.width);
    
    }
    return _ruleDescriptionButton;
}


- (ZZSignInView *)signInView {
    if (!_signInView) {
        _signInView = [[ZZSignInView alloc]init];
        WS(weakSelf);
        _signInView.signInBlock = ^{
            
            [weakSelf requestSign];
        };
    }
    return _signInView;
}


- (UIView *)signNormalLineView {
    if (!_signNormalLineView) {
        _signNormalLineView = [[UIView alloc]init];
        _signNormalLineView.backgroundColor = [UIColor whiteColor];
    }
    return _signNormalLineView;
}


/**
 黑色背景
 */
-  (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = RGBCOLOR(39, 39, 39);
    }
    return _bgView;
}

/**
 积分签到
 */
- (UILabel *)signInIntegralLab {
    if (!_signInIntegralLab) {
        _signInIntegralLab = [[UILabel alloc]init];
        _signInIntegralLab.textColor = RGBCOLOR(115, 91, 39);
        _signInIntegralLab.font =  ADaptedFontMediumSize(15);
        _signInIntegralLab.textAlignment = NSTextAlignmentCenter;
        _signInIntegralLab.numberOfLines = 0;
    }
    return _signInIntegralLab;
}

/**
 飞机
 */
- (UIImageView *)planeImageView {
    if (!_planeImageView) {
        _planeImageView = [[UIImageView alloc]init];
        _planeImageView.image = [UIImage imageNamed:@"icPlan"];
        _planeImageView.contentMode = UIViewContentModeScaleAspectFit;
        _planeImageView.hidden = YES;
    }
    return _planeImageView;
}

- (UIView *)signLineLab {
    if (!_signLineLab) {
        _signLineLab = [[UIView alloc]init];
    }
    return _signLineLab;
}
#pragma  mark - 约束

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.equalTo(self.bgView.mas_width).multipliedBy(285/375.0f);
    }];

    [self.cardBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(7);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.equalTo(self.cardBgImageView.mas_width).multipliedBy(170/345.0f);
    }];
    
  
    [self.ruleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardBgImageView.mas_bottom).offset(-2);
        make.bottom.left.right.offset(0);
    }];
    
    [self.signInView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(AdaptedWidth(80), AdaptedWidth(80)));
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.centerY.equalTo(self.bgView.mas_centerY).multipliedBy(0.55);
    }];
}


/**
 设置约束
 */
- (void)setUpTheConstraints {
    ZZCircularView *lastView;
    float width = SCREEN_WIDTH -30;
    float spaceWidth = (width -35*7)/6.0f;
    
    for (int x = 0; x<7; x++) {
        ZZCircularView *circularView = [[ZZCircularView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        [self.bgView addSubview:circularView];
        circularView.tag  = 200+x;
        [circularView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cardBgImageView.mas_bottom).offset(14);
            if (x==0) {
                make.left.equalTo(self.cardBgImageView.mas_left);
            }else{
                make.left.equalTo(lastView.mas_right).offset(spaceWidth);
            }
            if (x ==7) {
                make.right.equalTo(self.cardBgImageView.mas_right);
            }
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        lastView = circularView;
        //积分
        UILabel *lab = [[UILabel alloc]init];
        [self.bgView addSubview:lab];
        lab.font = ADaptedFuturaBoldSize(13);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(circularView);
        }];
        lab.tag  = 300+x;
        
        //天数
        UILabel *dayTimeLab = [[UILabel alloc]init];
        dayTimeLab.font = [UIFont fontWithName:@"Futura-Medium" size:13];
        dayTimeLab.textAlignment = NSTextAlignmentCenter;
        dayTimeLab.textColor = [UIColor whiteColor];
        dayTimeLab.text = [NSString stringWithFormat:@"Day%d",1+x];
        [self.bgView addSubview:dayTimeLab];
        [dayTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(circularView.mas_centerX);
            make.bottom.equalTo(@(-12));
            make.height.equalTo(@15);
        }];
        
        if (x==0) {
            [self.planeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.cardBgImageView.mas_left).offset(-80);
                make.bottom.equalTo(dayTimeLab.mas_top);
                make.top.equalTo(circularView.mas_bottom);
            }];
            
            [self.signLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(circularView.mas_centerX);
                make.height.equalTo(@2);
                make.width.equalTo(@0);
                make.centerY.equalTo(self.planeImageView.mas_centerY);
            }];
            [self.signNormalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.cardBgImageView.mas_left).offset(17.5);
                make.height.equalTo(@2);
                make.right.equalTo(self.cardBgImageView.mas_right).offset(-17.5);
                make.centerY.equalTo(self.planeImageView.mas_centerY);
            }];
        }
        
        UIView *whiteCircleView = [[UIView alloc]init];
        [self.bgView addSubview:whiteCircleView];
        whiteCircleView.backgroundColor = [UIColor whiteColor];
        whiteCircleView.layer.cornerRadius = 2.5;
        whiteCircleView.tag = 400+x;
        [whiteCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.planeImageView.mas_centerY);
            make.centerX.equalTo(circularView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(5, 5));
        }];
        

        
    }
    //积分的占位图
    [self.integralImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(27);
        make.top.offset(20);
        make.height.equalTo(@15);
        make.width.equalTo(@16.5);
    }];
    
    //积分
    [self.integralLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.integralImage.mas_right).offset(4);
        make.centerY.equalTo(self.integralImage.mas_centerY);
    }];
    
    /**
     规则
     */
    [self.ruleDescriptionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.integralImage.mas_centerY);
        make.right.offset(-25);
        make.size.mas_equalTo(CGSizeMake(80, 44));
    }];
    
    /**
     连续签到的积分
     */
    [self.signInIntegralLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.equalTo(self.cardBgImageView.mas_bottom).with.offset(-15);
        make.height.equalTo(@50);
    }];
}

#pragma  mark - 点击事件

/**
 点亮签到
  @param signInIntegral :总的积分
 */
- (int )lightUpSignInLabWithSignInIntegral:(int)signInIntegral  withDay:(int)dayNumber {
    for (int i = 0; i<self.model.sign_task.score_list.count; i++) {
        if (i< dayNumber) {
            signInIntegral +=  [self.model.sign_task.score_list[i] intValue];
            ZZCircularView *view = [self.bgView viewWithTag:200+i];
            [view setSelect];
        }
        UILabel *lab = [self.bgView viewWithTag:300+i];
        lab.text = [NSString stringWithFormat:@"+%@",self.model.sign_task.score_list[i]];
    }
    NSLog(@"PY_签到的总积分%d",signInIntegral);

    return signInIntegral;
}


/**
 连续签到的展示

 @param dayNumber 签到天数
 @param signInIntegral 连续签到的积分
 */
- (void)setCustomSignDay:(NSString *)dayNumber signInIntegral:(NSString *)signInIntegral {
    
    NSString *signString = [NSString stringWithFormat:@"已经连续签到%@天 已经获得%@积分",dayNumber,signInIntegral];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:signString];
    
    //签到天数
    NSRange dayNumberRange = [signString rangeOfString:dayNumber];
  
    [attrString addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"Futura-Medium" size:15]
                       range:NSMakeRange(dayNumberRange.location,dayNumberRange.length)];
    //积分
    NSRange signInIntegralRange = [signString rangeOfString:[NSString stringWithFormat:@"得%@",signInIntegral]];

       [attrString addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"Futura-Medium" size:15]
                       range:NSMakeRange(signInIntegralRange.location+1,signInIntegralRange.length-1)];
    self.signInIntegralLab.attributedText = attrString;
}

/**
 规则详情
 */
- (void)ruleDescriptionButtonClick {
    if (self.ruleBlock) {
        self.ruleBlock();
    }
}
@end
