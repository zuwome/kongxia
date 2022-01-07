//
//  ZZFindTypeView.m
//  zuwome
//
//  Created by angBiu on 16/8/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZFindTypeView.h"

#define Left                (60)
#define Current_Width       (SCREEN_WIDTH - 60 * 2)

@implementation ZZFindTypeView
{
    UIButton                *_tempBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = kYellowColor;
        self.btns = [NSMutableArray new];
        
        NSArray *titleArray = @[@"附近",@"发现",@"关注"];
        CGFloat width = Current_Width / titleArray.count;
        for (int i=0; i<titleArray.count; i++) {
            UIButton *btn = [[UIButton alloc] init];
            [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitle:titleArray[i] forState:UIControlStateSelected];
            [btn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
            [btn setTitleColor:kBlackTextColor forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.tag = 100 + i;
            btn.titleLabel.alpha = 0.6f;
            [self addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left).offset(Left + width*i);
                make.top.mas_equalTo(self.mas_top).offset(STATUSBAR_HEIGHT);
                make.bottom.mas_equalTo(self.mas_bottom);
                make.width.mas_equalTo(width);
            }];
            
            if (i == 1) {
                _lineView = [[ZZLineView alloc] init];
                [self addSubview:_lineView];
                btn.titleLabel.alpha = 1.0f;
                [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.mas_left).offset(Left + (width - 50)/2 + width);
                    make.bottom.mas_equalTo(self.mas_bottom);
                    make.size.mas_equalTo(CGSizeMake(50, 3));
                }];
                
                btn.selected = YES;
                _tempBtn = btn;
            }
            
            [self.btns addObject:btn];
        }
        
        CGFloat titleWidth = [ZZUtils widthForCellWithText:titleArray[2] fontSize:15];
        
        _rightRedPointView = [[UIView alloc] init];
        _rightRedPointView.backgroundColor = kRedPointColor;
        _rightRedPointView.layer.cornerRadius = 5;
        _rightRedPointView.clipsToBounds = YES;
        _rightRedPointView.hidden = YES;
        [self addSubview:_rightRedPointView];
        
        [_rightRedPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(Left + Current_Width/6.0 * 5.0 + titleWidth/2 + 3);
            make.centerY.mas_equalTo(_tempBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
    
    return self;
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
//        make.left.mas_equalTo(self.mas_left).offset((SCREEN_WIDTH/2 - 50)/2 + offset);
        make.left.mas_equalTo(self.mas_left).offset(60 + (Current_Width/3 - 50)/2 + offset);//3个type
    }];
}

- (void)setLineIndex:(NSInteger)index {
    
    UIButton *btn = (UIButton *)[self viewWithTag:index + 100];
    _tempBtn.selected = NO;
    btn.selected = YES;
    _tempBtn = btn;
    
    [self.btns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == index + 100) {
            obj.titleLabel.alpha = 1.0f;
        } else {
            obj.titleLabel.alpha = 0.6f;
        }
    }];
}

@end
