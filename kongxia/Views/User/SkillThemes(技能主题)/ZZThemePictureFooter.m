//
//  ZZThemePictureFooter.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZThemePictureFooter.h"

@interface ZZThemePictureFooter ()

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *exampleBtn;

@end

@implementation ZZThemePictureFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@-15);
        make.height.greaterThanOrEqualTo(@20);
        make.bottom.equalTo(@0);
    }];
    
//    [self addSubview:self.exampleBtn];
//    [self.exampleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.tipLabel.mas_bottom).offset(8);
//        make.bottom.equalTo(@-8);
//        make.leading.equalTo(@15);
//        make.width.equalTo(@80);
//        make.height.equalTo(@20);
//    }];
}

//查看照片示例
- (void)checkPictureExampleClick {
    !self.checkPictureExample ? : self.checkPictureExample();
}

- (UILabel *)tipLabel {
    if (nil == _tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"*上传与技能相关的高质量图片，让大家更清楚了解你的技能。\n*照片中包含微信、qq、手机号、二维码、色情内容的照片会导致照片审核无法通过。";
        _tipLabel.textColor = RGBCOLOR(190, 190, 190);
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UIButton *)exampleBtn {
    if (nil == _exampleBtn) {
        NSString *str = @"查看照片示例";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr setAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(74, 144, 226),
                                 NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}
                         range:NSMakeRange(0, str.length)];
        
        _exampleBtn = [[UIButton alloc] init];
        [_exampleBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
        _exampleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_exampleBtn addTarget:self action:@selector(checkPictureExampleClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exampleBtn;
}

@end
