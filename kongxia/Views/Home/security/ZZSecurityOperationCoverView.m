//
//  ZZSecurityOperationCoverView.m
//  zuwome
//
//  Created by angBiu on 2017/8/21.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSecurityOperationCoverView.h"

@interface ZZSecurityOperationCoverView ()

@property (nonatomic, strong) UIView *clearView;

@end

@implementation ZZSecurityOperationCoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _clearView.backgroundColor = [UIColor clearColor];
        [self addSubview:_clearView];
        
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = HEXACOLOR(0x000000, 0.55);
        [self addSubview:topView];
        
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self);
            make.bottom.mas_equalTo(_clearView.mas_top);
        }];
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = HEXACOLOR(0x000000, 0.55);
        [self addSubview:bottomView];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.top.mas_equalTo(_clearView.mas_bottom);
        }];
    }
    
    return self;
}

- (void)setClearRect:(CGRect)clearRect
{
    if (CGRectIsEmpty(_clearRect)) {
        _clearView.frame = clearRect;
    } else {
        [UIView animateWithDuration:0.8 animations:^{
            _clearView.frame = clearRect;
        }];
    }
    _clearRect = clearRect;
}

@end
