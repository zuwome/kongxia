//
//  ZZMemedaAnswerCell.m
//  zuwome
//
//  Created by angBiu on 16/8/8.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMemedaAnswerCell.h"

#import "ZZMemedaModel.h"

@implementation ZZMemedaAnswerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kBGColor;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.left.mas_equalTo(self.contentView.mas_left).offset(0);
            make.right.mas_equalTo(self.contentView.mas_right).offset(0);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = kBlackTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        [bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(10);
            make.top.mas_equalTo(bgView.mas_top).offset(10);
            make.right.mas_equalTo(bgView.mas_right).offset(-10);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [bgView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentLabel.mas_left);
            make.right.mas_equalTo(_contentLabel.mas_right);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(@0.5);
        }];
        
        _headImgView = [[ZZHeadImageView alloc] init];
        [bgView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lineView.mas_left);
            make.top.mas_equalTo(lineView.mas_bottom).offset(10);
            make.bottom.mas_equalTo(bgView.mas_bottom).offset(-10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        WeakSelf;
        _headImgView.touchHead = ^{
            [weakSelf headBtnClick];
        };
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = kBlackTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(10);
            make.top.mas_equalTo(_headImgView.mas_top);
            make.bottom.mas_equalTo(_headImgView.mas_centerY);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = kGrayTextColor;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.top.mas_equalTo(_headImgView.mas_centerY);
            make.bottom.mas_equalTo(_headImgView.mas_bottom);
        }];
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.textColor = kYellowColor;
        _statusLabel.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(lineView.mas_right);
            make.centerY.mas_equalTo(_timeLabel.mas_centerY);
        }];
    }
    
    return self;
}

- (void)setData:(ZZMemedaModel *)model
{
    [_headImgView setUser:model.mmd.from width:50 vWidth:12];
    _headImgView.isAnonymous = model.mmd.is_anonymous;
    _nameLabel.text = model.mmd.from.nickname;
    _timeLabel.text = model.mmd.created_at_text;
    _statusLabel.text = model.mmd.status_text;
    
    if ([model.mmd.status isEqualToString:@"wait_answer"]) {
        _statusLabel.textColor = kRedTextColor;
    } else if ([model.mmd.status isEqualToString:@"answered"]) {
        _statusLabel.textColor = kYellowColor;
    } else if ([model.mmd.status isEqualToString:@"expired"]) {
        _statusLabel.textColor = kGrayTextColor;
    }
    _contentLabel.text = model.mmd.content;
}

- (void)headBtnClick
{
    if (_touchHead) {
        _touchHead();
    }
}

@end
