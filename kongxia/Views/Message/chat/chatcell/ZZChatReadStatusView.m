//
//  ZZChatReadStatusView.m
//  zuwome
//
//  Created by angBiu on 16/10/9.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatReadStatusView.h"

@implementation ZZChatReadStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXCOLOR(0x83CB8B);
        self.layer.cornerRadius = 2;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:9];
        self.text = @"已读";
    }
    return self;
}

@end
