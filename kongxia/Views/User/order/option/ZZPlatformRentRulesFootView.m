//
//  ZZPlatformRentRules.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPlatformRentRulesFootView.h"
@interface ZZPlatformRentRulesFootView()
@property (nonatomic,strong) UIImageView     *imageLeftView;
@property (nonatomic,strong) UIButton     *imageRightButton;
@property (nonatomic,strong) UILabel         *titleLab;
@property (nonatomic,strong) UILabel         *detailLab;

@end
@implementation ZZPlatformRentRulesFootView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 210);
        [self addSubview:self.imageLeftView];
        [self addSubview:self.titleLab];
        [self addSubview:self.imageRightButton];

        [self addSubview:self.detailLab];
    }
    return self;
}

- (void)setRentRulesString:(NSString*)ruleString {

    NSString * htmlString = ruleString;
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attrStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10.5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    
    self.detailLab.attributedText = attributedString;
    
}

- (UIImageView *)imageLeftView {
    if (!_imageLeftView) {
        _imageLeftView = [[UIImageView alloc]init];
        _imageLeftView.image = [UIImage imageNamed:@"rentInfoPrompt"];
    }
    return _imageLeftView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = @"常见违规行为";
        _titleLab.textColor = kBlackColor;
        _titleLab.font = CustomFont(14);
        _titleLab.userInteractionEnabled = YES;
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}
- (UIButton *)imageRightButton {
    if (!_imageRightButton) {
        _imageRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageRightButton addTarget:self action:@selector(clickDetail) forControlEvents:UIControlEventTouchUpInside];
        [_imageRightButton setImage:[UIImage imageNamed:@"icDetails"] forState:UIControlStateNormal];

    }
    return _imageRightButton;
}

- (void)clickDetail {
     NSLog(@"PY_查看违规详情");
    if (self.touchHead) {
        self.touchHead();
    }
}
- (UILabel *)detailLab {
    if (!_detailLab) {
        _detailLab = [[UILabel alloc]init];
        _detailLab.numberOfLines = 0;
    }
    return _detailLab;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.height.equalTo(@16);
        make.width.equalTo(@3);
        make.top.offset(20);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageLeftView.mas_right).offset(5);
        make.centerY.equalTo(self.imageLeftView.mas_centerY);
        make.right.equalTo(self.imageRightButton.mas_left).offset(8);
    }];
    [self.imageRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imageLeftView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageLeftView.mas_bottom).offset(10);
        make.left.offset(14.5);
        make.right.offset(-14.5);
        make.height.lessThanOrEqualTo(@195);
    }];
    
}
@end
