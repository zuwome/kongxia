//
//  ZZTopicDetailHeadView.m
//  zuwome
//
//  Created by angBiu on 2017/4/17.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTopicDetailHeadView.h"

@implementation ZZTopicDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.topicImgView];
        self.topicLabel.text = @"#小火车污污污污#";
        self.typeImgView.image = [UIImage imageNamed:@"icon_find_hot_p"];
        self.contentLabel.text = @"哈哈";
    }
    
    return self;
}

#pragma mark - 

- (UIImageView *)topicImgView
{
    if (!_topicImgView) {
        _topicImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2.3)];
        _topicImgView.contentMode = UIViewContentModeScaleAspectFill;
        _topicImgView.backgroundColor = kGrayTextColor;
        _topicImgView.clipsToBounds = YES;
        
        UIView *coverView = [[UIView alloc] init];
        coverView.backgroundColor = kBlackTextColor;
        coverView.layer.cornerRadius = 3;
        coverView.alpha = 0.5;
        [_topicImgView addSubview:coverView];
        
        [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_topicImgView);
        }];
    }
    return _topicImgView;
}

- (UILabel *)topicLabel
{
    if (!_topicLabel) {
        _topicLabel = [[UILabel alloc] init];
        _topicLabel.textColor = [UIColor whiteColor];
        _topicLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:_topicLabel];
        
        [_topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(12);
            make.bottom.mas_equalTo(self.mas_top).offset(SCREEN_WIDTH/2.3 - 15);
        }];
    }
    return _topicLabel;
}

- (UIImageView *)typeImgView
{
    if (!_typeImgView) {
        _typeImgView = [[UIImageView alloc] init];
        [self addSubview:_typeImgView];
        
        [_typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(12);
            make.bottom.mas_equalTo(_topicLabel.mas_top).offset(-8);
            make.size.mas_equalTo(CGSizeMake(14.3, 16.8));
        }];
        
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.font = [UIFont systemFontOfSize:13];
        _typeLabel.text = @"热门话题";
        [self addSubview:_typeLabel];
        
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_typeImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(_typeImgView.mas_centerY);
        }];
    }
    return _typeImgView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(_topicLabel.mas_bottom).offset(15);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
        }];
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = kBGColor;
        [self addSubview:bottomView];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(8);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kBlackTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH - 24);
            make.left.mas_equalTo(bgView.mas_left).offset(12);
            make.right.mas_equalTo(bgView.mas_right).offset(-12);
            make.top.mas_equalTo(bgView.mas_top).offset(8);
            make.bottom.mas_equalTo(bgView.mas_bottom).offset(-8);
        }];
    }
    return _contentLabel;
}

@end
