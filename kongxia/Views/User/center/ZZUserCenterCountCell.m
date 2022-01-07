//
//  ZZUserCenterCountCell.m
//  zuwome
//
//  Created by angBiu on 16/10/10.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserCenterCountCell.h"

@implementation ZZUserCenterCountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIButton *attentBtn = [[UIButton alloc] init];
        [attentBtn addTarget:self action:@selector(attentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:attentBtn];
        
        [attentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH/3);
        }];
        
        UIButton *fansBtn = [[UIButton alloc] init];
        [fansBtn addTarget:self action:@selector(fansBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:fansBtn];
        
        [fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(attentBtn.mas_right);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH/3);
        }];
        
        UIButton *levelBtn = [[UIButton alloc] init];
        [levelBtn addTarget:self action:@selector(levelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:levelBtn];
        
        [levelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(fansBtn.mas_right);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH/3);
        }];
        
        UIView *firLineView = [[UIView alloc] init];
        firLineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:firLineView];
        
        [firLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.centerX.mas_equalTo(attentBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(1, 28));
        }];
        
        UIView *secLineView = [[UIView alloc] init];
        secLineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:secLineView];
        
        [secLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.centerX.mas_equalTo(fansBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(1, 28));
        }];
        
        UILabel *attentLabel = [[UILabel alloc] init];
        attentLabel.textAlignment = NSTextAlignmentCenter;
        attentLabel.textColor = HEXCOLOR(0x858585);
        attentLabel.font = [UIFont systemFontOfSize:12];
        attentLabel.text = @"关注";
        attentLabel.userInteractionEnabled = NO;
        [self.contentView addSubview:attentLabel];
        
        [attentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(attentBtn.mas_centerX);
            make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        }];
        
        _attentCountLabel = [[UILabel alloc] init];
        _attentCountLabel.textAlignment = NSTextAlignmentCenter;
        _attentCountLabel.textColor = HEXCOLOR(0x858585);
        _attentCountLabel.font = [UIFont systemFontOfSize:14];
        _attentCountLabel.userInteractionEnabled = NO;
        [self.contentView addSubview:_attentCountLabel];
        
        [_attentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(attentLabel.mas_centerX);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
        }];
        
        UILabel *fansLabel = [[UILabel alloc] init];
        fansLabel.textAlignment = NSTextAlignmentCenter;
        fansLabel.textColor = HEXCOLOR(0x858585);
        fansLabel.font = [UIFont systemFontOfSize:12];
        fansLabel.text = @"粉丝";
        fansLabel.userInteractionEnabled = NO;
        [self.contentView addSubview:fansLabel];
        
        [fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(fansBtn.mas_centerX);
            make.top.mas_equalTo(attentLabel.mas_top);
        }];
        
        _fansCountLabel = [[UILabel alloc] init];
        _fansCountLabel.textAlignment = NSTextAlignmentCenter;
        _fansCountLabel.textColor = HEXCOLOR(0x858585);
        _fansCountLabel.font = [UIFont systemFontOfSize:14];
        _fansCountLabel.userInteractionEnabled = NO;
        [self.contentView addSubview:_fansCountLabel];
        
        [_fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(fansLabel.mas_centerX);
            make.bottom.mas_equalTo(_attentCountLabel.mas_bottom);
        }];
        
        UILabel *levelLabel = [[UILabel alloc] init];
        levelLabel.textAlignment = NSTextAlignmentCenter;
        levelLabel.textColor = HEXCOLOR(0x858585);
        levelLabel.font = [UIFont systemFontOfSize:12];
        levelLabel.text = @"等级";
        levelLabel.userInteractionEnabled = NO;
        [self.contentView addSubview:levelLabel];
        
        [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(levelBtn.mas_centerX);
            make.top.mas_equalTo(attentLabel.mas_top);
        }];
        
        _levelCountLabel = [[UILabel alloc] init];
        _levelCountLabel.textAlignment = NSTextAlignmentCenter;
        _levelCountLabel.textColor = HEXCOLOR(0x858585);
        _levelCountLabel.font = [UIFont systemFontOfSize:14];
        _levelCountLabel.userInteractionEnabled = NO;
        [self.contentView addSubview:_levelCountLabel];
        
        [_levelCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(levelLabel.mas_centerX);
            make.bottom.mas_equalTo(_attentCountLabel.mas_bottom);
        }];
    }
    
    return self;
}

- (void)setData:(ZZUser *)user
{
    _attentCountLabel.text = [NSString stringWithFormat:@"%ld",(long)user.following_count];
    _fansCountLabel.text = [NSString stringWithFormat:@"%ld",(long)user.follower_count];
    _levelCountLabel.text = [NSString stringWithFormat:@"LV.%ld",(long)user.level];
}

#pragma mark - UIButtonMethod

- (void)attentBtnClick
{
    if (_touchAttent) {
        _touchAttent();
    }
}

- (void)fansBtnClick
{
    if (_touchFans) {
        _touchFans();
    }
}

- (void)levelBtnClick
{
    if (_touchLevel) {
        _touchLevel();
    }
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
