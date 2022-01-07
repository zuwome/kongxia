//
//  ZZMemedaTypeView.m
//  zuwome
//
//  Created by angBiu on 16/8/5.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMemedaTypeView.h"

@implementation ZZMemedaTypeView
{
    UILabel             *_tempLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        NSArray *array = @[@"作品",@"我答",@"我问"];
        CGFloat width = SCREEN_WIDTH/array.count;
        for (int i=0; i<array.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = kBlackTextColor;
            label.font = [UIFont systemFontOfSize:15];
            label.text = array[i];
            label.userInteractionEnabled = YES;
            label.tag = 100 + i;
            [self addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left).offset(i*width);
                make.top.mas_equalTo(self.mas_top);
                make.bottom.mas_equalTo(self.mas_bottom);
                make.width.mas_equalTo(width);
            }];
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
            recognizer.numberOfTapsRequired = 1;
            [label addGestureRecognizer:recognizer];
            
            if (i==0) {
                label.textColor = kYellowColor;
                _tempLabel = label;
                
                _lineView = [[UIView alloc] init];
                _lineView.backgroundColor = kYellowColor;
                [self addSubview:_lineView];
                
                [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.mas_left);
                    make.bottom.mas_equalTo(self.mas_bottom);
                    make.width.mas_equalTo(width);
                    make.height.mas_equalTo(@2);
                }];
            }
        }
        
        CGFloat titleWidth = [ZZUtils widthForCellWithText:array[1] fontSize:15];
        
        _redPointView = [[UIView alloc] init];
        _redPointView.backgroundColor = kRedPointColor;
        _redPointView.layer.cornerRadius = 5;
        _redPointView.clipsToBounds = YES;
        _redPointView.hidden = YES;
        [self addSubview:_redPointView];
        
        [_redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset((SCREEN_WIDTH/6)*5 + titleWidth/2 + 3);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        _badgeView = [[ZZBadgeView alloc] init];
        _badgeView.cornerRadius = 7.5;
        _badgeView.offset = 5;
        _badgeView.fontSize = 9;
        _badgeView.count = 99;
        _badgeView.hidden = YES;
        [self addSubview:_badgeView];
        
        [_badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).offset((SCREEN_WIDTH/6)*3 + titleWidth/2 + 5);
            make.height.mas_equalTo(@15);
        }];
    }
    
    return self;
}

- (void)labelClick:(UITapGestureRecognizer *)recognizer
{
    UILabel *label = (UILabel *)recognizer.view;
    
    if (_tempLabel == label) {
        return;
    }
    
    [self manageStatus:label.tag - 100];
    
    if (_touchType) {
        _touchType(label.tag - 100);
    }
}

- (void)setLineViewOffset:(CGFloat)offset
{
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(offset);
    }];
}

- (void)setIndex:(NSInteger)index
{
    [self manageStatus:index];
    CGFloat width = SCREEN_WIDTH/3.0;
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(index*width);
    }];
}

- (void)manageStatus:(NSInteger)index
{
    _tempLabel.textColor = kBlackTextColor;
    UILabel *label = (UILabel *)[self viewWithTag:(index + 100)];
    label.textColor = kYellowColor;
    _tempLabel = label;
}

@end
