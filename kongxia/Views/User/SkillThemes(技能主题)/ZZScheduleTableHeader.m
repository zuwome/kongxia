//
//  ZZScheduleTableHeader.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZScheduleTableHeader.h"

@implementation ZZScheduleTableHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"选择你的空闲时间（可多选）";
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:14];
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@-15);
        make.height.equalTo(@20);
    }];
    
    UILabel *subTitle = [[UILabel alloc] init];
    subTitle.numberOfLines = 0;
    subTitle.text = @"早上为9点以后，下午为12点以后，晚上为18点以后。";
    subTitle.textColor = RGBCOLOR(171, 171, 171);
    subTitle.font = [UIFont systemFontOfSize:13];
    [self addSubview:subTitle];
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(10);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@-15);
        make.bottom.equalTo(@-10);
    }];
}

@end
