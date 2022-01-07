//
//  ZZChatTopView.m
//  zuwome
//
//  Created by angBiu on 2017/4/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZChatTopView.h"

#import "ZZGradientView.h"

@implementation ZZChatTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _rentBtn = [[UIButton alloc] init];
        _rentBtn.backgroundColor = kYellowColor;
        [_rentBtn setTitle:@"马上预约" forState:UIControlStateNormal];
        [_rentBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _rentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _rentBtn.layer.cornerRadius = 3;
        _rentBtn.clipsToBounds = YES;
        [_rentBtn addTarget:self action:@selector(rentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rentBtn];
        
        [_rentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(80, 32));
        }];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = kBlackTextColor;
        _priceLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_priceLabel];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_rentBtn.mas_left).offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        _skillLabel = [[UILabel alloc] init];
        _skillLabel.textColor = kBlackTextColor;
        _skillLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_skillLabel];
        
        [_skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.right.mas_equalTo(_priceLabel.mas_left).offset(-10);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        ZZGradientView *gradientView = [[ZZGradientView alloc] initWithFrame:CGRectMake(0, -15, 80, 32+30)];
        [_rentBtn addSubview:gradientView];
        
        [gradientView showTime:1.5];
        
        self.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 0.9;
        self.layer.shadowRadius = 1;
    }
    
    return self;
}

- (void)setUser:(ZZUser *)user
{
    if (user.rent.topics.count) {
        ZZTopic *topic = user.rent.topics[0];
        _skillLabel.text = [topic title];
        _priceLabel.text = [NSString stringWithFormat:@"%@元/小时", topic.price];
    }
    CGFloat width = [ZZUtils widthForCellWithText:_priceLabel.text fontSize:15];
    [_priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

- (void)rentBtnClick
{
    if (_touchRent) {
        _touchRent();
    }
}

@end
