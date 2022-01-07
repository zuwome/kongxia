//
//  ZZFindTopicCell.m
//  zuwome
//
//  Created by angBiu on 2017/4/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZFindTopicCell.h"

@implementation ZZFindTopicCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imgView.backgroundColor = kGrayTextColor;
        self.typeLabel.text = @"热门话题";
        self.contentLabel.text = @"小火车污污污污";
        self.boomBgImgView.hidden = NO;
        self.peopleLabel.text = @"1000人参与";
        self.readLabel.text = @"1000围观";
    }
    
    return self;
}

- (void)setData:(ZZTopicGroupModel *)model
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
    self.contentLabel.text = model.content;
    self.peopleLabel.text = [NSString stringWithFormat:@"%ld人参与",model.video_count];
    self.readLabel.text = [NSString stringWithFormat:@"%ld人围观",model.browser_count];
}

#pragma mark - lazyload

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.cornerRadius = 3;
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        UIView *coverView = [[UIView alloc] init];
        coverView.backgroundColor = kBlackTextColor;
        coverView.layer.cornerRadius = 3;
        coverView.alpha = 0.5;
        [_imgView addSubview:coverView];
        
        [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_imgView);
        }];
    }
    return _imgView;
}

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kYellowColor;
        bgView.layer.cornerRadius = 9;
        [self.contentView addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
            make.top.mas_equalTo(self.contentView.mas_top).offset(8);
            make.height.mas_equalTo(@18);
        }];
        
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.textColor = kBlackTextColor;
        _typeLabel.font = [UIFont systemFontOfSize:11];
        [bgView addSubview:_typeLabel];
        
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(6);
            make.right.mas_equalTo(bgView.mas_right).offset(-6);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
    }
    return _typeLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        UIView *bgView = [[UIView alloc] init];
        [self.contentView addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_find_topic"];
        [bgView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgView.mas_top);
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imgView.mas_bottom).offset(15);
            make.bottom.mas_equalTo(bgView.mas_bottom);
            make.left.mas_equalTo(bgView.mas_left).offset(10);
            make.right.mas_equalTo(bgView.mas_right).offset(-10);
        }];
    }
    return _contentLabel;
}

- (UIImageView *)boomBgImgView
{
    if (!_boomBgImgView) {
        _boomBgImgView = [[UIImageView alloc] init];
        _boomBgImgView.contentMode = UIViewContentModeScaleToFill;
        _boomBgImgView.image = [UIImage imageNamed:@"icon_rent_bottombg"];
        [_imgView addSubview:_boomBgImgView];
        
        [_boomBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(_imgView);
            make.height.mas_equalTo(@50);
        }];
    }
    return _boomBgImgView;
}

- (UILabel *)peopleLabel
{
    if (!_peopleLabel) {
        _peopleLabel = [[UILabel alloc] init];
        _peopleLabel.textColor = [UIColor whiteColor];
        _peopleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_peopleLabel];
        
        [_peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
        }];
    }
    return _peopleLabel;
}

- (UILabel *)readLabel
{
    if (!_readLabel) {
        _readLabel = [[UILabel alloc] init];
        _readLabel.textColor = [UIColor whiteColor];
        _readLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_readLabel];
        
        [_readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
            make.centerY.mas_equalTo(_peopleLabel.mas_centerY);
        }];
    }
    return _readLabel;
}

@end
