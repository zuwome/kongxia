//
//  ZZOrderListHeadView.m
//  zuwome
//
//  Created by angBiu on 16/8/31.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZOrderListHeadView.h"

@implementation ZZOrderListHeadView
{
    UIButton                    *_tempBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        NSArray *titleArray = @[@"全部",@"进行中",@"待评价",@"已结束"];
        CGFloat firstWidth = SCREEN_WIDTH/5.0;
        CGFloat lastWidth = (SCREEN_WIDTH - firstWidth)/3.0;
        CGFloat btnWidth = 0;
        CGFloat offsetX = 0;
        for (int i=0; i<titleArray.count; i++) {
            if (i==0) {
                btnWidth = firstWidth;
            } else {
                btnWidth = lastWidth;
            }
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 0, btnWidth, self.height)];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitle:titleArray[i] forState:UIControlStateSelected];
            [btn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
            [btn setTitleColor:kYellowColor forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            if (i == 0) {
                btn.selected = YES;
                _tempBtn = btn;
            }
            offsetX = offsetX + btnWidth;
        }
        
        CGFloat lineWidth = SCREEN_WIDTH/titleArray.count - 30;
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 - lineWidth, self.height - 2, lineWidth, 2)];
        _lineView.backgroundColor = kYellowColor;
        [self addSubview:_lineView];
        
        _lineView.center = CGPointMake(_tempBtn.center.x, self.height - _lineView.height);
        
        CGFloat width = [ZZUtils widthForCellWithText:@"哈哈哈" fontSize:14];
        CGFloat halfWidth = btnWidth/2.0;
        
        _ingBadgeView = [[ZZBadgeView alloc] init];
        _ingBadgeView.cornerRadius = 7.5;
        _ingBadgeView.offset = 5;
        _ingBadgeView.fontSize = 9;
        _ingBadgeView.count = 99;
        [self addSubview:_ingBadgeView];
        
        [_ingBadgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).offset(firstWidth+halfWidth + width/2 + 5);
            make.height.mas_equalTo(@15);
        }];
        
        _commentRedPointView = [self getRedPointView];
        [self addSubview:_commentRedPointView];
        
        [_commentRedPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(firstWidth+3*halfWidth + width/2 + 5);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        _doneRedPointView = [self getRedPointView];
        [self addSubview:_doneRedPointView];
        
        [_doneRedPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(firstWidth+5*halfWidth + width/2 + 5);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        self.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 0.9;
        self.layer.shadowRadius = 1;
    }
    
    return self;
}

- (UIView *)getRedPointView
{
    UIView *redPointView = [[UIView alloc] init];
    redPointView.userInteractionEnabled = NO;
    redPointView.layer.cornerRadius = 5;
    redPointView.backgroundColor = kRedPointColor;
    redPointView.hidden = YES;
    
    return redPointView;
}

#pragma mark -

- (void)typeBtnClick:(UIButton *)sender
{
    if (_tempBtn == sender) {
        return;
    }
    
    [self setSelectIndex:(sender.tag - 100)];
    
    if (_selectedIndex) {
        _selectedIndex(sender.tag - 100);
    }
}

- (void)setSelectIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[self viewWithTag:(index + 100)];
    _tempBtn.selected = NO;
    btn.selected = YES;
    _tempBtn = btn;
    
    _lineView.center = CGPointMake(_tempBtn.center.x, self.height - _lineView.height);
}

@end
