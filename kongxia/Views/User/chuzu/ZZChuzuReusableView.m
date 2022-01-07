//
//  ZZChuzuReusableView.m
//  zuwome
//
//  Created by angBiu on 2016/11/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChuzuReusableView.h"

@implementation ZZChuzuReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *moneyLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:17 text:@"￥"];
        [self addSubview:moneyLabel];
        
        CGFloat width = [ZZUtils widthForCellWithText:@"￥" fontSize:17];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.centerY.mas_equalTo(self.mas_top).offset(25);
            make.width.mas_equalTo(width+3);
        }];
        
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.textColor = kGrayTextColor;
        _unitLabel.font = [UIFont systemFontOfSize:15];
        _unitLabel.text = @"元/小时";
        [self addSubview:_unitLabel];
        
        _textField = [[ZZMoneyTextField alloc] init];
        _textField.pure = YES;
        _textField.textColor = kBlackTextColor;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.placeholder = @"最受欢迎的价格区间为1~200元/小时";
        [self addSubview:_textField];
        [_textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(moneyLabel.mas_right).offset(5);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.top.mas_equalTo(self.mas_top);
            make.height.mas_equalTo(@50);
        }];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 35)];
        bottomView.backgroundColor = kBGColor;
        [self addSubview:bottomView];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.top.mas_equalTo(_textField.mas_bottom);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 35)];
        titleLabel.textColor = kGrayContentColor;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = @"请选择相应的技能（可多选）";
        [bottomView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bottomView.mas_left).offset(15);
            make.right.mas_equalTo(bottomView.mas_right).offset(-15);
            make.bottom.mas_equalTo(bottomView.mas_bottom);
            make.height.mas_equalTo(@35);
        }];
        
        _infoLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kYellowColor fontSize:13 text:@""];
        [bottomView addSubview:_infoLabel];
        
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bottomView.mas_left).offset(15);
            make.right.mas_equalTo(bottomView.mas_right).offset(-15);
            make.top.mas_equalTo(bottomView.mas_top);
            make.bottom.mas_equalTo(titleLabel.mas_top);
        }];
    }
    
    return self;
}

- (void)textValueChanged:(UITextField *)textField
{
    if (textField.text.length > 8) {
        textField.text = [textField.text substringToIndex:8];
    }
    
    if (_textChange) {
        _textChange();
    }
    
    if (textField.text.length == 0) {
        _unitLabel.hidden = YES;
    } else {
        _unitLabel.hidden = NO;
    }
    CGFloat width = [ZZUtils widthForCellWithText:textField.text fontSize:15];
    [_unitLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_textField.mas_centerY);
        make.left.mas_equalTo(_textField.mas_left).offset(width+5);
    }];
}

- (void)setPriceValue
{
    [self textValueChanged:_textField];
}

@end
