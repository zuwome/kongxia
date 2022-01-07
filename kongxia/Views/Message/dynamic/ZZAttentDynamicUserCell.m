//
//  ZZAttentDynamicUserCell.m
//  zuwome
//
//  Created by angBiu on 16/8/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZAttentDynamicUserCell.h"

@implementation ZZAttentDynamicUserCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _headImgView = [[ZZHeadImageView alloc] init];
        _headImgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    
    return self;
}

- (void)setUser:(ZZUser *)user width:(CGFloat)width
{
    [_headImgView setUser:user width:width vWidth:12];
}

@end
