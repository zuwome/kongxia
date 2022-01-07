//
//  ZZAttentDynamicMMDCell.m
//  zuwome
//
//  Created by angBiu on 16/8/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZAttentDynamicMMDCell.h"

@implementation ZZAttentDynamicMMDCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _headImgView = [[UIImageView alloc] init];
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headImgView.clipsToBounds = YES;
        _headImgView.backgroundColor = kBGColor;
        [self.contentView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    
    return self;
}

@end
