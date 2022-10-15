//
//  ZZRentDynamicCell.m
//  zuwome
//
//  Created by angBiu on 16/8/3.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentDynamicCell.h"

@implementation ZZRentDynamicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _headImgView = [[ZZHeadImageView alloc] init];
        [self.contentView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headImgView.mas_centerY).offset(-10);
            make.left.mas_equalTo(self.contentView.mas_left).offset(60);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        }];
        
        _videoImgView = [[UIImageView alloc] init];
        _videoImgView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImgView.clipsToBounds = YES;
        [self.contentView addSubview:_videoImgView];
        
        [_videoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(20);
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(SCREEN_WIDTH);
        }];
        
        _timeView = [[ZZFindVideoTimeView alloc] init];
        _timeView.timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeView];
        
        [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_videoImgView.mas_right).offset(-12);
            make.top.mas_equalTo(_videoImgView.mas_top).offset(12);
            make.height.mas_equalTo(@24);
        }];
        
        UIImageView *playImgView = [[UIImageView alloc] init];
        playImgView.image = [UIImage imageNamed:@"btn_video_play"];
        [self.contentView addSubview:playImgView];
        
        [playImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_videoImgView.mas_centerX);
            make.centerY.mas_equalTo(_videoImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(56, 56));
        }];
        
        _contributionView = [[ZZRentDynamicContributionView alloc] init];
        [self.contentView addSubview:_contributionView];
        
        [_contributionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_videoImgView.mas_bottom);
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(60);
        }];
        
        UIImageView *readImgView = [[UIImageView alloc] init];
        readImgView.image = [UIImage imageNamed:@"icon_rent_dynamic_read"];
        readImgView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:readImgView];
        
        [readImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contributionView.mas_bottom).offset(15);
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-30);
            make.size.mas_equalTo(CGSizeMake(21.5, 14));
        }];
        
        _readCountLabel = [[UILabel alloc] init];
        _readCountLabel.textAlignment = NSTextAlignmentLeft;
        _readCountLabel.textColor = kBlackTextColor;
        _readCountLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_readCountLabel];
        
        [_readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(readImgView.mas_right).offset(3);
            make.centerY.mas_equalTo(readImgView.mas_centerY);
        }];
        
        UIImageView *commentImgView = [[UIImageView alloc] init];
        commentImgView.image = [UIImage imageNamed:@"icon_rent_dynamic_comment"];
        [self.contentView addSubview:commentImgView];
        
        [commentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(readImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15.9, 14.5));
        }];
        
        _commentCountLabel = [[UILabel alloc] init];
        _commentCountLabel.textAlignment = NSTextAlignmentLeft;
        _commentCountLabel.textColor = kBlackTextColor;
        _commentCountLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_commentCountLabel];
        
        [_commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(commentImgView.mas_right).offset(3);
            make.centerY.mas_equalTo(commentImgView.mas_centerY);
        }];
        
        _zanCountLabel = [[UILabel alloc] init];
        _zanCountLabel.textAlignment = NSTextAlignmentRight;
        _zanCountLabel.textColor = kBlackTextColor;
        _zanCountLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_zanCountLabel];
        
        [_zanCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(commentImgView.mas_centerY);
        }];
        
        _zanImgView = [[UIImageView alloc] init];
        _zanImgView.image = [UIImage imageNamed:@"icon_rent_dynamic_zan_n"];
        [self.contentView addSubview:_zanImgView];
        
        [_zanImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_zanCountLabel.mas_left).offset(-3);
            make.centerY.mas_equalTo(_zanCountLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = kBGColor;
        [self.contentView addSubview:bottomView];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(@15);
        }];
        
    }
    
    return self;
}

- (void)setData:(ZZUserVideoListModel *)model
{
    if (model.sk.id) {
        [_headImgView setUser:model.sk.user width:38 vWidth:10];
        _titleLabel.text = model.sk.content;
        _readCountLabel.text = [NSString stringWithFormat:@"%ld",model.sk.browser_count];
        _commentCountLabel.text = [NSString stringWithFormat:@"%ld",model.sk.reply_count];
        _zanCountLabel.text = [NSString stringWithFormat:@"%ld",model.sk.like_count];
        [_videoImgView sd_setImageWithURL:[model.sk.video.cover_url widthOfQiniuURL:SCREEN_WIDTH]];
        [_contributionView setTips:model.sk_tips];
        [_timeView.typeImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 15));
        }];
        _timeView.typeImgView.image = [UIImage imageNamed:@"icon_video_sk"];
        _timeView.timeLabel.text = [NSString stringWithFormat:@"%.f秒",model.sk.video.time];
        if (model.sk_tips.count) {
            [_contributionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@50);
            }];
        } else {
            [_contributionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@0);
            }];
        }
    } else {
        [_headImgView setUser:model.mmd.from width:38 vWidth:10];
        _titleLabel.text = model.mmd.content;
        _readCountLabel.text = [NSString stringWithFormat:@"%ld",model.mmd.browser_count];
        _commentCountLabel.text = [NSString stringWithFormat:@"%ld",model.mmd.reply_count];
        _zanCountLabel.text = [NSString stringWithFormat:@"%ld",model.mmd.like_count];
        if (model.mmd.answers.count) {
            ZZMMDAnswersModel *answerModel = model.mmd.answers[0];
            [_videoImgView sd_setImageWithURL:[answerModel.video.cover_url widthOfQiniuURL:SCREEN_WIDTH]];
            [_timeView.typeImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(17, 17));
            }];
            _timeView.typeImgView.image = [UIImage imageNamed:@"icon_video_mmd"];
            _timeView.timeLabel.text = [NSString stringWithFormat:@"%.f秒",answerModel.video.time];
        }
        [_contributionView setTips:model.mmd_tips];
        if (model.mmd_tips.count) {
            [_contributionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@50);
            }];
        } else {
            [_contributionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@0);
            }];
        }
    }
    
    CGFloat height = [ZZUtils heightForCellWithText:@"哈哈哈" fontSize:15 labelWidth:SCREEN_WIDTH];
    if (isNullString(_titleLabel.text)) {
        [_videoImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(19 + height);
        }];
    } else {
        [_videoImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(19);
        }];
    }
    
    if (model.like_status) {
        _zanImgView.image = [UIImage imageNamed:@"icon_rent_dynamic_zan_p"];
    } else {
        _zanImgView.image = [UIImage imageNamed:@"icon_rent_dynamic_zan_n"];
    }
}

- (void)setMMDData:(ZZMemedaModel *)model
{
    [_headImgView setUser:model.mmd.from width:38 vWidth:10];
    _titleLabel.text = model.mmd.content;
    _readCountLabel.text = [NSString stringWithFormat:@"%ld",model.mmd.browser_count];
    _commentCountLabel.text = [NSString stringWithFormat:@"%ld",model.mmd.reply_count];
    _zanCountLabel.text = [NSString stringWithFormat:@"%ld",model.mmd.like_count];
    if (model.mmd.answers.count) {
        ZZMMDAnswersModel *answerModel = model.mmd.answers[0];
        [_videoImgView sd_setImageWithURL:[answerModel.video.cover_url widthOfQiniuURL:SCREEN_WIDTH]];
        [_timeView.typeImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
        _timeView.typeImgView.image = [UIImage imageNamed:@"icon_video_mmd"];
        _timeView.timeLabel.text = [NSString stringWithFormat:@"%.f秒",answerModel.video.time];
    }
    [_contributionView setTips:model.mmd_tips];
    if (model.mmd_tips.count) {
        [_contributionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@50);
        }];
    } else {
        [_contributionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0);
        }];
    }
    if (model.like_status) {
        _zanImgView.image = [UIImage imageNamed:@"icon_rent_dynamic_zan_p"];
    } else {
        _zanImgView.image = [UIImage imageNamed:@"icon_rent_dynamic_zan_n"];
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
