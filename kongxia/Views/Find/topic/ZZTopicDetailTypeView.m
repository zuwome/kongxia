//
//  ZZTopicTypeView.m
//  zuwome
//
//  Created by angBiu on 2017/4/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTopicDetailTypeView.h"

@interface ZZTopicDetailTypeView ()

@property (nonatomic, strong) UIButton *tempBtn;

@end

@implementation ZZTopicDetailTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray *titleArray = @[@"精选",@"最新"];
        
        CGFloat width = SCREEN_WIDTH/2.0;
        for (int i=0; i<titleArray.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*width, 0, width, frame.size.height)];
            [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 100 + i;
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
            [btn setTitle:titleArray[i] forState:UIControlStateSelected];
            [btn setTitleColor:kYellowColor forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [self addSubview:btn];
            
            if (i==0) {
                btn.selected = YES;
                _tempBtn = btn;
            }
        }
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kYellowColor;
        _lineView.userInteractionEnabled = NO;
        [self addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left).offset((SCREEN_WIDTH - 200)/4.0);
            make.size.mas_equalTo(CGSizeMake(100, 2));
        }];
    }
    
    return self;
}

- (void)typeBtnClick:(UIButton *)btn
{
    if (btn != _tempBtn) {
        _tempBtn.selected = NO;
        btn.selected = YES;
        _tempBtn = btn;
        NSInteger index = btn.tag - 100;
        [self setLineViewOffset:index * SCREEN_WIDTH/2.0];
        if (_selectIndex) {
            _selectIndex(index);
        }
    }
}

- (void)setLineViewOffset:(CGFloat)offset
{
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(offset+(SCREEN_WIDTH - 200)/4.0);
    }];
    
    NSInteger index = 2*offset/SCREEN_WIDTH;
    UIButton *btn = (UIButton *)[self viewWithTag:100+index];
    if (btn != _tempBtn) {
        _tempBtn.selected = NO;
        btn.selected = YES;
        _tempBtn = btn;
    }
}

- (void)setIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[self viewWithTag:100+index];
    [self typeBtnClick:btn];
}

@end
