//
//  ZZLineView.m
//  zuwome
//
//  Created by angBiu on 16/9/29.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZLineView.h"

@implementation ZZLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.userInteractionEnabled = NO;
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        imgView.image = [[UIImage imageNamed:@"icon_black_line"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 10, 1, 10)];
    }
    
    return self;
}

@end
