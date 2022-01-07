//
//  ZZUserEditPhotoAddCell.m
//  zuwome
//
//  Created by angBiu on 2017/3/8.
//  Copyright © 2017年 zz. All rights reserved.
//
 
#import "ZZUserEditPhotoAddCell.h"

#import "ZZBorderView.h"

@implementation ZZUserEditPhotoAddCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor = kBGColor;
        
        ZZBorderView *borderView = [[ZZBorderView alloc] init];
        [self.contentView addSubview:borderView];
        
        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"ThemePicAdd"];
        imgView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-17);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        UILabel *tipLab = [[UILabel alloc] init];
        tipLab.tag = 101;
        tipLab.text = @"添加照片\n展示你的兴趣特长";
        tipLab.textColor = kGrayTextColor;
        tipLab.font = [UIFont systemFontOfSize:12];
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.numberOfLines = 2;
        [self.contentView addSubview:tipLab];
        [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom).offset(10);
            make.centerX.equalTo(self.contentView);
            make.leading.equalTo(@10);
            make.trailing.bottom.equalTo(@-10);
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
        [self addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (void)tapSelf
{
    if (_touchSelf) {
        _touchSelf();
    }
}

- (void)setType:(PhotoEditType)type {
    _type = type;
    UILabel *tipLab = (UILabel *)[self.contentView viewWithTag:101];
    tipLab.text = type == EditTypeSkill ? @"添加技能照片\n展示你的兴趣特长" : @"添加照片\n展示你的兴趣特长";
}

@end
