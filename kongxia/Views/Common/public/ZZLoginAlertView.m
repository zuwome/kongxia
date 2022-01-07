//
//  ZZLoginAlertView.m
//  zuwome
//
//  Created by wlsy on 16/1/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZLoginAlertView.h"

@implementation ZZLoginAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = HEXCOLOR(0xDCA000);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        self.backgroundColor = HEXCOLOR(0xF6F0C6);
        self.hidden = YES;
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.hidden = YES;
}

- (void)showAlertMsg:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *label = [self.subviews firstObject];
        label.text = msg;
        self.hidden = NO;
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // code to be executed on the main queue after delay
            self.hidden = YES;
        });
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
