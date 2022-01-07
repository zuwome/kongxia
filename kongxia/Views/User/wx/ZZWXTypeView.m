//
//  ZZWXTypeView.m
//  zuwome
//
//  Created by angBiu on 2017/6/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZWXTypeView.h"

@interface ZZWXTypeView ()

@property (nonatomic, strong) UIButton *tempBtn;

@end

@implementation ZZWXTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kYellowColor;
        
        NSArray *titleArray = @[@"我的微信号",@"已查看的微信"];
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
                make.top.mas_equalTo(self.mas_top).offset(20);
                make.bottom.mas_equalTo(self.mas_bottom);
                make.width.mas_equalTo(width);
            }];
            
            if (i == 0) {
                _lineView = [[ZZLineView alloc] init];
                [self addSubview:_lineView];
                
                [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.mas_left).offset((width - 100)/2);
                    make.bottom.mas_equalTo(self.mas_bottom);
                    make.size.mas_equalTo(CGSizeMake(100, 3));
                }];
                
                btn.selected = YES;
                _tempBtn = btn;
            }
        }
        
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUSBARBar_Y_HEIGHT, 60, 44)];
        
        [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        
        UIImageView *leftImgView = [[UIImageView alloc] init];
        leftImgView.image = [UIImage imageNamed:@"back"];
        leftImgView.userInteractionEnabled = NO;
        [leftBtn addSubview:leftImgView];
        
        [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftBtn.mas_left).offset(15);
            make.centerY.mas_equalTo(leftBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 16.5));
        }];
    }
    
    return self;
}

- (void)leftBtnClick {
    if (_touchLeft) {
        _touchLeft();
    }
}

- (void)typeBtnClick:(UIButton *)sender {
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

- (void)setLineViewOffset:(CGFloat)offset {
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset((SCREEN_WIDTH/2 - 100)/2 + offset);
    }];
}

- (void)setLineIndex:(NSInteger)index {
    UIButton *btn = (UIButton *)[self viewWithTag:index + 100];
    _tempBtn.selected = NO;
    btn.selected = YES;
    _tempBtn = btn;
}

@end
