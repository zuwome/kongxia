//
//  ZZChatHeadLodingView.m
//  zuwome
//
//  Created by angBiu on 2016/11/8.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatHeadLodingView.h"

@implementation ZZChatHeadLodingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _indocatorView = [[UIActivityIndicatorView alloc] init];
        _indocatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _indocatorView.hidesWhenStopped = NO;
        [self addSubview:_indocatorView];
        
        [_indocatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    
    return self;
}

@end
