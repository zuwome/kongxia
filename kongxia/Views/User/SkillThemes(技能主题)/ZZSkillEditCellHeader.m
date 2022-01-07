//
//  ZZSkillEditCellHeader.m
//  zuwome
//
//  Created by MaoMinghui on 2018/7/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillEditCellHeader.h"

@interface ZZSkillEditCellHeader ()

@property (nonatomic, strong) UILabel *headerTitle;

@end

@implementation ZZSkillEditCellHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    [self addSubview:self.headerTitle];
    [self.headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@17);
    }];
}

- (void)setTitleText:(NSString *)text {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:@"*"];
    [attrStr setAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(224, 69, 57)} range:range];
    self.headerTitle.attributedText = attrStr;
}

- (UILabel *)headerTitle {
    if (nil == _headerTitle) {
        _headerTitle = [[UILabel alloc] init];
        [_headerTitle setFont:[UIFont systemFontOfSize:12]];
    }
    return _headerTitle;
}

@end
