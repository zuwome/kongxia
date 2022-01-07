//
//  ZZMessageCommentEmptyView.m
//  zuwome
//
//  Created by angBiu on 2017/8/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZMessageCommentEmptyView.h"

@implementation ZZMessageCommentEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kBGColor;
        
        CGFloat scale = SCREEN_WIDTH /375.0;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_comment_empty"];
        [self addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top).offset(80*scale);
            make.size.mas_equalTo(CGSizeMake(138.5, 148.5));
        }];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = HEXCOLOR(0xa5a5a5);
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.text = @"你太低调了 快去发个视频吧";
        [self addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(imgView.mas_bottom).offset(20);
        }];
        
        UIButton *recordBtn = [[UIButton alloc] init];
        [recordBtn setTitle:@"发布视频" forState:UIControlStateNormal];
        [recordBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        recordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [recordBtn addTarget:self action:@selector(recordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        recordBtn.backgroundColor = kYellowColor;
        recordBtn.layer.cornerRadius = 3;
        [self addSubview:recordBtn];
        
        [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(contentLabel.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(104, 44));
        }];
    }
    
    return self;
}

- (void)recordBtnClick
{
    if (_touchRecord) {
        _touchRecord();
    }
}

@end
