//
//  ZZTotalContributionBottomView.m
//  zuwome
//
//  Created by angBiu on 2016/10/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZTotalContributionBottomView.h"

@implementation ZZTotalContributionBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _levelLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:HEXCOLOR(0xADADB1) fontSize:21 text:@""];
        [self addSubview:_levelLabel];
        
        [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(27);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        _headImgView = [[ZZHeadImageView alloc] init];
        [self addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_levelLabel.mas_right).offset(12);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(49, 49));
        }];
        
        _nameLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:15 text:@""];
        [self addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(12);
            make.top.mas_equalTo(_headImgView.mas_top);
        }];
        
        _levelImgView = [[ZZLevelImgView alloc] init];
        [self addSubview:_levelImgView];
        
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 14));
        }];
        
        _moneyLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:HEXCOLOR(0xADADB1) fontSize:14 text:@""];
        [self addSubview:_moneyLabel];
        
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.bottom.mas_equalTo(_headImgView.mas_bottom);
        }];
    }
    
    return self;
}

- (void)setData:(ZZMMDTipsModel *)model myRank:(NSInteger)rank
{
    _levelLabel.text = [NSString stringWithFormat:@"%ld",rank];
    [_headImgView setUser:model.from width:49 vWidth:10];
    _nameLabel.text = model.from.nickname;
    _moneyLabel.text = [NSString stringWithFormat:@"贡献 ¥%.2f",model.price];
    [_levelImgView setLevel:model.from.level];
}

@end
