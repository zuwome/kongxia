//
//  ZZRentPageTypeView.m
//  zuwome
//
//  Created by angBiu on 16/8/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentPageTypeView.h"

@implementation ZZRentPageTypeView
{
    UILabel                    *_tempLabel;
    NSArray                    *_titleArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        _titleArray = @[@"资料",@"视频"];
        CGFloat width = SCREEN_WIDTH/_titleArray.count;
        for (int i=0; i<_titleArray.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = kBlackTextColor;
            label.font = [UIFont systemFontOfSize:15];
            label.userInteractionEnabled = YES;
            label.text = _titleArray[i];
            label.tag = 100 + i;
            [_bgView addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(i*width);
                make.top.mas_equalTo(_bgView.mas_top);
                make.bottom.mas_equalTo(_bgView.mas_bottom);
                make.width.mas_equalTo(width);
            }];
            
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = 200+i;
            [btn addTarget:self action:@selector(labelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [label addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(label);
            }];
            
            if (i == 0) {
                _tempLabel = label;
            }
        }
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake((width - 112)/2, 37, 112, 3)];
        _lineView.backgroundColor = kYellowColor;
        [self addSubview:_lineView];
        
        _tempLabel.textColor = kYellowColor;
        
        self.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 0.9;
        self.layer.shadowRadius = 1;
    }
    
    return self;
}

- (void)setVideoCount:(NSInteger)videoCount
{
    _videoCount = videoCount;
    UILabel *label = (UILabel *)[self viewWithTag:101];
    if (videoCount <= 0) {
        label.text = @"视频";
    } else {
        label.text = [NSString stringWithFormat:@"视频(%ld)",videoCount];
    }
//    label.text = @"视频";
}

#pragma mark - PrivateMethod

- (void)setLineOffset:(CGFloat)offset {
    NSInteger index = offset / SCREEN_WIDTH;
    UILabel *label1 = (UILabel *)[_bgView viewWithTag:100 + index];
    UILabel *label2 = (UILabel *)[_bgView viewWithTag:100 + MIN(index + 1, _titleArray.count)];
    CGFloat posX1 = label1.frame.origin.x;
    CGFloat posX2 = label2.frame.origin.x;
    CGFloat disX = ABS(posX1 - posX2);
    CGFloat scaleX = disX / SCREEN_WIDTH;
    CGFloat lineX = offset * scaleX + label1.frame.size.width / 2 - _lineView.frame.size.width / 2;
    
    _lineView.frame = CGRectMake(lineX, _lineView.frame.origin.y, _lineView.frame.size.width, _lineView.frame.size.height);
    _tempLabel.textColor = kBlackTextColor;
    label1.textColor = kYellowColor;
    _tempLabel = label1;
}

- (void)setSelectIndex:(NSInteger)index {
    UIButton *btn = [self viewWithTag:200+index];
    [self labelBtnClick:btn];
}

#pragma mark - UIButtonMethod

- (void)labelBtnClick:(UIButton *)sender
{
    if (_selectType) {
        _selectType(sender.tag - 200);
    }
}

@end
