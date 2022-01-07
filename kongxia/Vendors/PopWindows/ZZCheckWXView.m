//
//  ZZCheckWXView.m
//  zuwome
//
//  Created by YuTianLong on 2017/10/19.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZCheckWXView.h"

@interface ZZCheckWXView ()

@property (nonatomic, assign) CGSize oldSize;
@property (nonatomic, strong) UIButton *checkButton;

@end

@implementation ZZCheckWXView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(self.size, self.oldSize)) {
        self.oldSize = self.size;
    }
}

- (void)setWxNumber:(NSString *)wxNumber {
    _wxNumber = wxNumber;
    
    NSString *infoString = [NSString stringWithFormat:@"TA的微信号: %@ 点击复制打开微信添加，您也可以去TA个人主页查看", self.wxNumber];
    NSRange range = [infoString rangeOfString:self.wxNumber];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", infoString]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, infoString.length)];
    [str addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(0, 0, 0, 0.5) range:NSMakeRange(0, infoString.length)];
    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(81, 148, 224) range:range];
    [_checkButton setAttributedTitle:str forState:UIControlStateNormal];
}

#pragma mark - Private methods

- (void)setupUI {
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    
    UIView *bgview = [[UIView alloc] initWithFrame:self.frame];
    bgview.backgroundColor = UIColor.blackColor;
    bgview.alpha = 0.4;
    [self addSubview:bgview];
    
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0f];
    backgroundView.layer.masksToBounds = YES;
    backgroundView.layer.cornerRadius = 10.0f;
    backgroundView.layer.borderWidth = 1.0f;
    backgroundView.layer.borderColor = RGBCOLOR(227, 227, 227).CGColor;
    
    UILabel *resultLabel = [[UILabel alloc] init];
    resultLabel.text = @"查看成功!";
    resultLabel.textColor = kBlackColor;
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.font = [UIFont systemFontOfSize:17];
    
    //bgPopSuccess
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgPopSuccess"]];
    [imageView sizeToFit];
    imageView.contentMode = UIViewContentModeCenter;
    
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _checkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _checkButton.titleLabel.numberOfLines = 0;
    [_checkButton addTarget:self action:@selector(checkWXNumberClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"知道了" forState:UIControlStateNormal];
    [doneButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"rectangle5"] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [backgroundView addSubview:resultLabel];
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:_checkButton];
    [backgroundView addSubview:doneButton];
    [self addSubview:backgroundView];
    
    [self setNeedsLayout];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@298);
//        make.height.equalTo(@298);
    }];

    [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundView);
        make.top.equalTo(backgroundView).offset(17);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resultLabel.mas_bottom).offset(15);
        make.centerX.equalTo(backgroundView);
        make.size.mas_equalTo(CGSizeMake(136.5, 74.0));
    }];
    
    [_checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundView);
        make.top.equalTo(imageView.mas_bottom).offset(14.0);
        make.trailing.equalTo(@(-20));
        make.leading.equalTo(@(20));
    }];
    
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_checkButton.mas_bottom).offset(15);
        make.centerX.equalTo(backgroundView);
        make.bottom.equalTo(backgroundView).offset((-13));
        make.size.mas_equalTo(CGSizeMake(263.5, 44));
    }];
    
    [self layoutIfNeeded];
}

// 复制微信号操作
- (IBAction)checkWXNumberClick:(id)sender {
    BLOCK_SAFE_CALLS(self.copyWXBlock);
}

// 我知道了
- (IBAction)doneClick:(id)sender {
    if (self.doneBlock) {
        _doneBlock();
        [self dismiss];
    }
    else {
        [self dismiss];
    }
}

- (void)show:(BOOL)animated {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //    window.alpha = 0.5;
    [window addSubview:self];
    animated ?
    [self shakeToShow:self] :
    nil;
}

- (void)dismiss {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.alpha = 1;
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self layoutSubviews];
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)shakeToShow:(UIView *)aView {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

@end
