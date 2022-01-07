//
//  ZZMessageDynamicHeadView.m
//  zuwome
//
//  Created by angBiu on 16/8/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMessageNotificationHeadView.h"

@implementation ZZMessageNotificationHeadView
{
    UIButton                *_tempBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = kYellowColor;
        
        NSArray *titleArray = @[@"互动",@"系统"];
        CGFloat width = SCREEN_WIDTH/titleArray.count;
        for (int i=0; i<titleArray.count; i++) {
            UIButton *btn = [[UIButton alloc] init];
            [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitle:titleArray[i] forState:UIControlStateSelected];
            [btn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
            [btn setTitleColor:kBlackTextColor forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.tag = 100 + i;
            [self addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left).offset(width*i);
                make.top.mas_equalTo(self.mas_top).offset(isIPhoneX ? 24 : 0);
                make.bottom.mas_equalTo(self.mas_bottom);
                make.width.mas_equalTo(width);
            }];
            
            if (i == 0) {
                _lineView = [[ZZLineView alloc] init];
                [self addSubview:_lineView];
                
                [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo((width - 50)/2);
                    make.bottom.mas_equalTo(self.mas_bottom);
                    make.size.mas_equalTo(CGSizeMake(50, 3));
                }];
                
                btn.selected = YES;
                _tempBtn = btn;
            }
        }
        
        CGFloat titleWidth = [ZZUtils widthForCellWithText:titleArray[1] fontSize:15];
        
        _rightRedPointView = [[UIView alloc] init];
        _rightRedPointView.backgroundColor = kRedPointColor;
        _rightRedPointView.layer.cornerRadius = 5;
        _rightRedPointView.clipsToBounds = YES;
        _rightRedPointView.hidden = YES;
        [self addSubview:_rightRedPointView];
        
        [_rightRedPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(SCREEN_WIDTH/4 * 3 + titleWidth/2 + 3);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top).offset(isIPhoneX ? 24 : 0);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.width.mas_equalTo(@70);
        }];
        
        UIImageView *leftImgView = [[UIImageView alloc] init];
        leftImgView.image = [UIImage imageNamed:@"back"];
        leftImgView.contentMode = UIViewContentModeLeft;
        leftImgView.userInteractionEnabled = NO;
        [leftBtn addSubview:leftImgView];
        
        [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftBtn.mas_left).offset(15);
            make.top.mas_equalTo(leftBtn.mas_top);
            make.bottom.mas_equalTo(leftBtn.mas_bottom);
            make.right.mas_equalTo(leftBtn.mas_right);
        }];
    }
    
    return self;
}

- (void)leftBtnClick
{
    if (_touchLeft) {
        _touchLeft();
    }
}

- (void)typeBtnClick:(UIButton *)sender
{
    if (_tempBtn == sender) {
        return;
    }
    
    _tempBtn.selected = NO;
    sender.selected = YES;
    _tempBtn = sender;
    NSInteger index = sender.tag - 100;
    
    if (_selectIndex) {
        _selectIndex(index);
    }
}

- (void)setLineViewOffset:(CGFloat)offset
{
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset((SCREEN_WIDTH/2 - 50)/2 + offset);
    }];
}

- (void)setLineIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[self viewWithTag:index + 100];
    _tempBtn.selected = NO;
    btn.selected = YES;
    _tempBtn = btn;
}

@end
