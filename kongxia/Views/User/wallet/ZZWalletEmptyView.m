//
//  ZZWalletEmptyView.m
//  zuwome
//
//  Created by angBiu on 16/5/25.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZWalletEmptyView.h"

@implementation ZZWalletEmptyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_wallet_money"];
        [self addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.textColor = kGrayTextColor;
        _infoLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_infoLabel];
        
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imgView.mas_bottom).offset(5);
            make.centerX.mas_equalTo(imgView.mas_centerX);
        }];
    }
    
    return self;
}

@end
