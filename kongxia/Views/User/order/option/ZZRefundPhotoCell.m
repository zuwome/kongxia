//
//  ZZRefundPhotoCell.m
//  zuwome
//
//  Created by angBiu on 16/9/13.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRefundPhotoCell.h"

@implementation ZZRefundPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor = HEXCOLOR(0xF2F6F9);
        
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = HEXCOLOR(0xF2F6F9);
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    
    return self;
}

@end
