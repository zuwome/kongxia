//
//  ZZChuzuSkillCell.m
//  zuwome
//
//  Created by angBiu on 2016/11/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChuzuSkillCell.h"

@implementation ZZChuzuSkillCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _titleLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentCenter textColor:[UIColor lightGrayColor] fontSize:15 text:@""];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" andAlpha:1].CGColor;
        self.contentView.layer.borderWidth = self.selected ? 0: 1;
        self.contentView.layer.cornerRadius = 2;
    }
    
    return self;
}

- (void)setCellSelected:(BOOL)selected
{
    if (selected) {
        self.contentView.layer.borderWidth = 0;
        self.contentView.backgroundColor = kYellowColor;
        _titleLabel.textColor = kBlackTextColor;
    } else {
        self.contentView.layer.borderWidth = 1;
        self.contentView.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = [UIColor lightGrayColor];
    }
}

@end
