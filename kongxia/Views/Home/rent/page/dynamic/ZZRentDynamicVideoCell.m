//
//  ZZRentDynamicVideoCell.m
//  zuwome
//
//  Created by angBiu on 2017/2/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRentDynamicVideoCell.h"

@implementation ZZRentDynamicVideoCell
{
    CGFloat             _width;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _width = SCREEN_WIDTH - 12 - 30/2;
        
        [self createViews];
    }
    
    return self;
}

- (void)createViews
{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(@0.5);
    }];
    
    self.typeImgView.hidden = NO;
    self.contentLabel.text = @"回答了1个么么答，获得打赏1000元回答了1个么么答，获得打赏1000元回答了1个么么答，获得打赏1000元回答了1个么么答，获得打赏1000元";
    self.timeLabel.text = @" 15分钟前";
    self.coverImgView.backgroundColor = kBGColor;
    self.readCountView.imgView.image = [UIImage imageNamed:@"icon_dynamic_count_read"];
    self.commentCountView.imgView.image = [UIImage imageNamed:@"icon_dynamic_count_comment"];
    self.zanCountView.imgView.image = [UIImage imageNamed:@"icon_dynamic_count_zan"];
}

- (void)setData:(ZZUserVideoListModel *)model
{
    if ([model.type isEqualToString:@"sk"]) {
        _timeLabel.text = model.sk.created_at_text;
        _contentLabel.text = model.content;
        _videoContentLabel.text = model.sk.content;
        [_coverImgView sd_setImageWithURL:[NSURL URLWithString:model.sk.video.cover_url]];
        _typeImgView.image = [UIImage imageNamed:@"icon_dynamic_sk"];
        _videoTimeView.typeImgView.image = [UIImage imageNamed:@"icon_video_sk"];
        _videoTimeView.timeLabel.text = [NSString stringWithFormat:@"%.f秒",model.sk.video.time];
        self.readCountView.countLabel.text = [ZZUtils getCountStringWithCount:model.sk.browser_count];
        self.commentCountView.countLabel.text = [ZZUtils getCountStringWithCount:model.sk.reply_count];
        self.zanCountView.countLabel.text = [ZZUtils getCountStringWithCount:model.sk.like_count];
    } else {
        _timeLabel.text = model.mmd.answer_at_text;
        _contentLabel.text = model.content;
        _videoContentLabel.text = model.mmd.content;
        ZZMMDAnswersModel *answerModel = model.mmd.answers[0];
        [_coverImgView sd_setImageWithURL:[NSURL URLWithString:answerModel.video.cover_url]];
        _typeImgView.image = [UIImage imageNamed:@"icon_dynamic_mmd"];
        _videoTimeView.typeImgView.image = [UIImage imageNamed:@"icon_video_mmd"];
        _videoTimeView.timeLabel.text = [NSString stringWithFormat:@"%.f秒",answerModel.video.time];
        self.readCountView.countLabel.text = [ZZUtils getCountStringWithCount:model.mmd.browser_count];
        self.commentCountView.countLabel.text = [ZZUtils getCountStringWithCount:model.mmd.reply_count];
        self.zanCountView.countLabel.text = [ZZUtils getCountStringWithCount:model.mmd.like_count];
    }
}

#pragma mark - lazyload

- (UIImageView *)typeImgView
{
    if (!_typeImgView) {
        _typeImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_typeImgView];
        
        [_typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(12);
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_typeImgView.mas_centerX);
            make.top.bottom.mas_equalTo(self.contentView);
            make.width.mas_equalTo(@1.5);
        }];
        
        [self.contentView bringSubviewToFront:_typeImgView];
    }
    return _typeImgView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kBlackTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_typeImgView.mas_right).offset(10);
            make.top.mas_equalTo(_typeImgView.mas_top).offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        }];
    }
    return _contentLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kGrayContentColor;
        _timeLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentLabel.mas_left);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(3);
        }];
    }
    return _timeLabel;
}

- (UIImageView *)coverImgView
{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImgView.clipsToBounds = YES;
        [self.contentView addSubview:_coverImgView];
        
        [_coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(5);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
            make.top.mas_equalTo(_timeLabel.mas_bottom).offset(14);
            make.height.mas_equalTo(SCREEN_WIDTH - 10);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-56);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"btn_video_play"];
        [_coverImgView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(52, 52));
        }];
        
        _videoTimeView = [[ZZFindVideoTimeView alloc] init];
        _videoTimeView.timeLabel.font = [UIFont systemFontOfSize:12];
        [_coverImgView addSubview:_videoTimeView];
        
        [_videoTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_coverImgView.mas_right).offset(-8);
            make.top.mas_equalTo(_coverImgView.mas_top).offset(8);
            make.height.mas_equalTo(@24);
        }];
        
        UIImageView *bgImgView = [[UIImageView alloc] init];
        bgImgView.image = [UIImage imageNamed:@"icon_rent_bottombg"];
        [_coverImgView addSubview:bgImgView];
        
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_coverImgView);
            make.height.mas_equalTo(@72);
        }];
        
        _videoContentLabel = [[UILabel alloc] init];
        _videoContentLabel.textColor = [UIColor whiteColor];
        _videoContentLabel.font = [UIFont systemFontOfSize:15];
        _videoContentLabel.numberOfLines = 0;
        [_coverImgView addSubview:_videoContentLabel];
        
        [_videoContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_coverImgView.mas_left).offset(15);
            make.right.mas_equalTo(_coverImgView.mas_right).offset(-15);
            make.bottom.mas_equalTo(_coverImgView.mas_bottom).offset(-15);
        }];
    }
    return _coverImgView;
}

- (ZZDynamicVideoCountView *)readCountView
{
    if (!_readCountView) {
        _readCountView = [[ZZDynamicVideoCountView alloc] init];
        [self.contentView addSubview:_readCountView];
        
        [_readCountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(SCREEN_WIDTH - _width);
            make.top.mas_equalTo(_coverImgView.mas_bottom);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(_width/3);
        }];
        
        [_readCountView.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22, 14));
        }];
    }
    return _readCountView;
}

- (ZZDynamicVideoCountView *)commentCountView
{
    if (!_commentCountView) {
        _commentCountView = [[ZZDynamicVideoCountView alloc] init];
        [self.contentView addSubview:_commentCountView];
        
        [_commentCountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_readCountView.mas_right);
            make.top.mas_equalTo(_coverImgView.mas_bottom);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(_width/3);
        }];
        
        [_commentCountView.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15.5, 14));
        }];
    }
    return _commentCountView;
}

- (ZZDynamicVideoCountView *)zanCountView
{
    if (!_zanCountView) {
        _zanCountView = [[ZZDynamicVideoCountView alloc] init];
        [self.contentView addSubview:_zanCountView];
        
        [_zanCountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_commentCountView.mas_right);
            make.top.mas_equalTo(_coverImgView.mas_bottom);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(_width/3);
        }];
        
        [_zanCountView.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
    }
    return _zanCountView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
