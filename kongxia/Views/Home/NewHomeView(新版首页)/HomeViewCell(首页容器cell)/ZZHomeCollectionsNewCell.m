//
//  ZZHomeCollectionsNewCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/6/13.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZHomeCollectionsNewCell.h"
#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>

@interface ZZHomeCollectionsNewCell ()

@property (nonatomic, strong) UIView *rankingView; // 这东西目前用作闪聊

@property (nonatomic, strong) FLAnimatedImageView *rankingIconImageView;

@property (nonatomic, strong) UILabel *rankingTitleLabel;

@property (nonatomic, strong) UILabel *rankingSubTitleLabel;

@property (nonatomic, strong) UIView *taskView;

@property (nonatomic, strong) UIImageView *taskIconImageView;

@property (nonatomic, strong) UILabel *taskTitleLabel;

@property (nonatomic, strong) UILabel *taskSubTitleLabel;

@property (nonatomic, strong) UIImageView *ranksView;

@property (nonatomic, strong) UIImageView *ranks1ImageView;

@property (nonatomic, strong) UIImageView *ranks2ImageView;

@property (nonatomic, strong) UIImageView *ranks3ImageView;

@property (nonatomic, strong) UIImageView *ranks1CrownImageView;

@property (nonatomic, strong) UIImageView *ranks2CrownImageView;

@property (nonatomic, strong) UIImageView *ranks3CrownImageView;

@property (nonatomic, strong) UIImageView *ranks1NoImageView;

@property (nonatomic, strong) UIImageView *ranks2NoImageView;

@property (nonatomic, strong) UIImageView *ranks3NoImageView;

@property (nonatomic, strong) UILabel *ranksTitleLabel;

@property (nonatomic, strong) UIImageView *ranksTitleIconImageView;

@property (nonatomic, strong) UILabel *ranksSubtitleLabel;

@end

@implementation ZZHomeCollectionsNewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureTopThree:(ZZRankResponeModel *)rankResponeMode {
    
    if (!rankResponeMode) {
        _rankingView.hidden = YES;
        _ranksView.hidden = YES;
        _taskView.frame = CGRectMake(7.0, 0.0, SCREEN_WIDTH - 14.0, 80.0);
    }
    else {
        CGFloat taskWidth = (SCREEN_WIDTH - 177 - 7 * 3);
        CGFloat taskHeight = 80.0;
        
//        if (rankResponeMode.charisma_show && rankResponeMode.rankWgShow) {
            _rankingView.hidden = NO;
            _ranksView.hidden = NO;
            
            _taskView.frame = CGRectMake(7.0, 0.0, taskWidth, taskHeight);
            _rankingView.frame = CGRectMake(7.0, _taskView.bottom + 7, taskWidth, taskHeight);
            _ranksView.frame = CGRectMake(_taskView.right + 7, 0.0, 177, 167);
//        }
//        else if (rankResponeMode.charisma_show && !rankResponeMode.rankWgShow) {
//            _rankingView.hidden = YES;
//            _ranksView.hidden = NO;
//
//            _taskView.frame = CGRectMake(7.0, 0.0, taskWidth, 167);
//            _ranksView.frame = CGRectMake(_taskView.right + 7, 0.0, 177, 167);
//            _rankingView.frame = CGRectMake(7.0, _taskView.bottom + 7, taskWidth, taskHeight);
//        }
//        else if (!rankResponeMode.charisma_show && rankResponeMode.rankWgShow) {
//            _rankingView.hidden = NO;
//            _ranksView.hidden = YES;
//
//            CGFloat taskWidth = (SCREEN_WIDTH - 7 * 3) / 2;
//            _taskView.frame = CGRectMake(7.0, 0.0, taskWidth, taskHeight);
//            _rankingView.frame = CGRectMake(_taskView.right + 7, 0.0, taskWidth, taskHeight);
//        }
//        else if (!rankResponeMode.charisma_show && !rankResponeMode.rankWgShow) {
//            _rankingView.hidden = YES;
//            _ranksView.hidden = YES;
//            _taskView.frame = CGRectMake(7.0, 0.0, SCREEN_WIDTH - 14.0, 80.0);
//        }
    }
    
    [self configurepopularityRanks:rankResponeMode];

}

- (void)configurepopularityRanks:(ZZRankResponeModel *)rankResponeMode {
//    if (!isNullString(rankResponeMode.pdSongTip[@"title"])) {
//        _rankingTitleLabel.text = rankResponeMode.pdSongTip[@"title"];
//    }
//    else {
//        _rankingTitleLabel.text = @"点唱Party";
//    }
//
//    if (!isNullString(rankResponeMode.pdSongTip[@"content"])) {
//        _rankingSubTitleLabel.text = rankResponeMode.pdSongTip[@"content"];
//    }
//    else {
//        _rankingSubTitleLabel.text = @"唱歌成功就能领礼物";
//    }

    _ranksSubtitleLabel.text = rankResponeMode.charisma_title;
    _ranksTitleLabel.text = rankResponeMode.charisma_b;
    
    [rankResponeMode.list_charisma_rank enumerateObjectsUsingBlock:^(ZZUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [_ranks1ImageView sd_setImageWithURL:[NSURL URLWithString:[obj displayAvatar]] placeholderImage:[UIImage imageNamed:@"icon_placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                UIImage *roundImage = [image imageAddCornerWithRadius:49 / 2 andSize:CGSizeMake(49, 49)];
                _ranks1ImageView.image = roundImage;
            }];
        }
        else if (idx == 1) {
            [_ranks2ImageView sd_setImageWithURL:[NSURL URLWithString:[obj displayAvatar]] placeholderImage:[UIImage imageNamed:@"icon_placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                UIImage *roundImage = [image imageAddCornerWithRadius:43 / 2 andSize:CGSizeMake(43, 43)];
                _ranks2ImageView.image = roundImage;
            }];
        }
        else if (idx == 2) {
            [_ranks3ImageView sd_setImageWithURL:[NSURL URLWithString:[obj displayAvatar]] placeholderImage:[UIImage imageNamed:@"icon_placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                UIImage *roundImage = [image imageAddCornerWithRadius:43 / 2 andSize:CGSizeMake(43, 43)];
                _ranks3ImageView.image = roundImage;
            }];
        }
    }];
    
    if (rankResponeMode.list_charisma_rank.count == 0) {
        _ranks1CrownImageView.hidden = YES;
        _ranks1NoImageView.hidden = YES;
        _ranks1ImageView.hidden = YES;
        _ranks2CrownImageView.hidden = YES;
        _ranks2NoImageView.hidden = YES;
        _ranks2ImageView.hidden = YES;
        _ranks3CrownImageView.hidden = YES;
        _ranks3NoImageView.hidden = YES;
        _ranks3ImageView.hidden = YES;
    }
    if (rankResponeMode.list_charisma_rank.count == 1) {
        _ranks2CrownImageView.hidden = YES;
        _ranks2NoImageView.hidden = YES;
        _ranks2ImageView.hidden = YES;
        _ranks3CrownImageView.hidden = YES;
        _ranks3NoImageView.hidden = YES;
        _ranks3ImageView.hidden = YES;
    }
    else if (rankResponeMode.list_charisma_rank.count == 2) {
        _ranks3CrownImageView.hidden = YES;
        _ranks3NoImageView.hidden = YES;
        _ranks3ImageView.hidden = YES;
    }
    else {
        _ranks1CrownImageView.hidden = NO;
        _ranks1NoImageView.hidden = NO;
        _ranks1ImageView.hidden = NO;
        _ranks2CrownImageView.hidden = NO;
        _ranks2NoImageView.hidden = NO;
        _ranks2ImageView.hidden = NO;
        _ranks3CrownImageView.hidden = NO;
        _ranks3NoImageView.hidden = NO;
        _ranks3ImageView.hidden = NO;
    }
}

#pragma mark - response method
- (void)showTask {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showTasks)]) {
        [self.delegate showTasks];
    }
}

- (void)showRanks {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showRanks)]) {
        [self.delegate showRanks];
    }
}

- (void)showPopularityRanks {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showPopularityRanks)]) {
        [self.delegate showPopularityRanks];
    }
}

#pragma mark - Layout
- (void)layout {
    CGFloat taskWidth = (SCREEN_WIDTH - 177 - 7 * 3);
    CGFloat taskHeight = 80.0;
    
    [self.contentView addSubview:self.taskView];
    [self.contentView addSubview:self.rankingView];
    [self.contentView addSubview:self.ranksView];
    
    // 通告
    [_taskView addSubview:self.taskIconImageView];
    [_taskView addSubview:self.taskTitleLabel];
    [_taskView addSubview:self.taskSubTitleLabel];
    
    _taskView.frame = CGRectMake(7.0, 0.0, taskWidth, taskHeight);
    [self.taskTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_taskView).offset(-15);
        make.centerX.equalTo(_taskView).offset(12);
    }];
    
    [self.taskIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.taskTitleLabel);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.trailing.equalTo(self.taskTitleLabel.mas_leading).offset(-3);
    }];
    
    [self.taskSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_taskView);
        make.centerY.equalTo(_taskView).offset(12);
    }];
    
    // 点唱机Party
    [_rankingView addSubview:self.rankingIconImageView];
    [_rankingView addSubview:self.rankingTitleLabel];
    [_rankingView addSubview:self.rankingSubTitleLabel];
    _rankingView.frame = CGRectMake(7.0, _taskView.bottom + 7, taskWidth, taskHeight);

    [self.rankingTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rankingView.mas_centerX).offset(SCALE_SET(-15));
        make.top.equalTo(_rankingView).offset(SCALE_SET(18));
    }];
    
    [self.rankingIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rankingTitleLabel.mas_left).offset(-2);
        make.centerY.equalTo(_rankingTitleLabel).offset(-1);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        //make.size.mas_equalTo(CGSizeMake(SCALE_SET(50), SCALE_SET(50)));
    }];
    
    [self.rankingSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rankingView);
        make.top.equalTo(_rankingTitleLabel.mas_bottom).offset(6);
    }];
    
    // 人气排行榜
    [_ranksView addSubview:self.ranks2ImageView];
    [_ranksView addSubview:self.ranks3ImageView];
    [_ranksView addSubview:self.ranks1ImageView];
    [_ranksView addSubview:self.ranks1CrownImageView];
    [_ranksView addSubview:self.ranks2CrownImageView];
    [_ranksView addSubview:self.ranks3CrownImageView];
    [_ranksView addSubview:self.ranks1NoImageView];
    [_ranksView addSubview:self.ranks2NoImageView];
    [_ranksView addSubview:self.ranks3NoImageView];
    [_ranksView addSubview:self.ranksTitleIconImageView];
    [_ranksView addSubview:self.ranksTitleLabel];
    [_ranksView addSubview:self.ranksSubtitleLabel];
    _ranksView.frame = CGRectMake(0.0, _taskView.right + 7, 177, 167);
    
    [_ranks1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_ranksView);
        make.top.equalTo(_ranksView).offset(34);
        make.size.mas_equalTo(CGSizeMake(49, 49));
    }];
    
    [_ranks2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ranks1ImageView).offset(-35);
        make.top.equalTo(_ranks1ImageView).offset(23);
        make.size.mas_equalTo(CGSizeMake(43, 43));
    }];
    
    [_ranks3ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ranks1ImageView).offset(42);
        make.top.equalTo(_ranks1ImageView).offset(23);
        make.size.mas_equalTo(CGSizeMake(43, 43));
    }];
    
   [_ranks1CrownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_ranks1ImageView).offset(-10);
        make.bottom.equalTo(_ranks1ImageView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(25, 20));
    }];
    
    [_ranks2CrownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ranks2ImageView).offset(3);
        make.bottom.equalTo(_ranks2ImageView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 16));
    }];
    
    [_ranks3CrownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_ranks3ImageView).offset(-3);
        make.bottom.equalTo(_ranks3ImageView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 16));
    }];
    
    [_ranks1NoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_ranks1ImageView);
        make.centerY.equalTo(_ranks1ImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    [_ranks2NoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_ranks2ImageView);
        make.centerY.equalTo(_ranks2ImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    [_ranks3NoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_ranks3ImageView);
        make.centerY.equalTo(_ranks3ImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    [_ranksTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_ranksView).offset(-5);
        make.top.equalTo(_ranks1ImageView.mas_bottom).offset(27.5);
    }];
    
    [_ranksTitleIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_ranksTitleLabel);
        make.left.equalTo(_ranksTitleLabel.mas_right).offset(4);
        make.size.mas_equalTo(CGSizeMake(4, 8));
    }];
    
    [_ranksSubtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_ranksView);
        make.top.equalTo(_ranksTitleLabel.mas_bottom).offset(4);
        make.left.equalTo(_ranksView).offset(5);
        make.right.equalTo(_ranksView).offset(-5);
    }];
    _ranks1ImageView.backgroundColor = UIColor.randomColor;
    _ranks2ImageView.backgroundColor = UIColor.randomColor;
    _ranks3ImageView.backgroundColor = UIColor.randomColor;
}

#pragma mark - getters and setters
- (UIView *)rankingView {
    if (!_rankingView) {
        _rankingView = [[UIView alloc] init];
        _rankingView.backgroundColor = ColorHex(fafafa);
        _rankingView.layer.cornerRadius = 3;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRanks)];
        [_rankingView addGestureRecognizer:tap];
    }
    return _rankingView;
}

- (UIView *)taskView {
    if (!_taskView) {
        _taskView = [[UIView alloc] init];
        _taskView.backgroundColor = ColorHex(fafafa);
        _taskView.layer.cornerRadius = 3;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTask)];
        [_taskView addGestureRecognizer:tap];
    }
    return _taskView;
}

- (UIImageView *)ranksView {
    if (!_ranksView) {
        _ranksView = [[UIImageView alloc] init];
        _ranksView.image = [UIImage imageNamed:@"home_ranks"];
        _ranksView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPopularityRanks)];
        [_ranksView addGestureRecognizer:tap];
    }
    return _ranksView;
}


- (FLAnimatedImageView *)rankingIconImageView {
    if (!_rankingIconImageView) {
        _rankingIconImageView = [[FLAnimatedImageView alloc] init];
        _rankingIconImageView.image = [UIImage imageNamed:@"icSpzxSy"];
//        NSURL *gifLocalUrl = [[NSBundle mainBundle] URLForResource:@"KTV_index" withExtension:@"gif"];
//        NSData *gifData = [NSData dataWithContentsOfURL:gifLocalUrl];
//        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
//        _rankingIconImageView.animatedImage = image;
    }
    return _rankingIconImageView;
}

- (UIImageView *)taskIconImageView {
    if (!_taskIconImageView) {
        _taskIconImageView = [[UIImageView alloc] init];
        _taskIconImageView.image = [UIImage imageNamed:@"rectangle54"];
    }
    return _taskIconImageView;
}

- (UILabel *)rankingTitleLabel {
    if (!_rankingTitleLabel) {
        _rankingTitleLabel = [[UILabel alloc] init];
        _rankingTitleLabel.font = ADaptedFontMediumSize(16);
        _rankingTitleLabel.text = @"视频咨询";//@"点唱机Party";
        _rankingTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _rankingTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _rankingTitleLabel;
}

- (UILabel *)taskTitleLabel {
    if (!_taskTitleLabel) {
        _taskTitleLabel = [[UILabel alloc] init];
        _taskTitleLabel.font = ADaptedFontMediumSize(16);
        _taskTitleLabel.text = @"全部通告";
        _taskTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _taskTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _taskTitleLabel;
}

- (UILabel *)rankingSubTitleLabel {
    if (!_rankingSubTitleLabel) {
        _rankingSubTitleLabel = [[UILabel alloc] init];
        _rankingSubTitleLabel.font = [UIFont systemFontOfSize:13.0];
        _rankingSubTitleLabel.text = @"在线1对1视频互动";//@"唱歌成功就能领礼物";
        _rankingSubTitleLabel.textColor = RGBCOLOR(153, 153, 153);
        _rankingSubTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rankingSubTitleLabel;
}

- (UILabel *)taskSubTitleLabel {
    if (!_taskSubTitleLabel) {
        _taskSubTitleLabel = [[UILabel alloc] init];
        _taskSubTitleLabel.font = [UIFont systemFontOfSize:13.0];
        _taskSubTitleLabel.text = @"海量通告 报名赚钱";
        _taskSubTitleLabel.textColor = RGBCOLOR(153, 153, 153);
        _taskSubTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _taskSubTitleLabel;
}

- (UIImageView *)ranks1ImageView {
    if (!_ranks1ImageView) {
        _ranks1ImageView = [[UIImageView alloc] init];
        _ranks1ImageView.layer.cornerRadius = 49 / 2;
        _ranks1ImageView.layer.borderColor = RGBCOLOR(255, 198, 66).CGColor;
        _ranks1ImageView.layer.borderWidth = 2;
    }
    return _ranks1ImageView;
}

- (UIImageView *)ranks2ImageView {
    if (!_ranks2ImageView) {
        _ranks2ImageView = [[UIImageView alloc] init];
        _ranks2ImageView.layer.cornerRadius = 43 / 2;
        _ranks2ImageView.layer.borderColor = RGBCOLOR(184, 196, 255).CGColor;
        _ranks2ImageView.layer.borderWidth = 2;
    }
    return _ranks2ImageView;
}

- (UIImageView *)ranks3ImageView {
    if (!_ranks3ImageView) {
        _ranks3ImageView = [[UIImageView alloc] init];
        _ranks3ImageView.layer.cornerRadius = 43 / 2;
        _ranks3ImageView.layer.borderColor = RGBCOLOR(255, 186, 146).CGColor;
        _ranks3ImageView.layer.borderWidth = 2;
    }
    return _ranks3ImageView;
}

- (UIImageView *)ranks1CrownImageView {
    if (!_ranks1CrownImageView) {
        _ranks1CrownImageView = [[UIImageView alloc] init];
        _ranks1CrownImageView.image = [UIImage imageNamed:@"rank-1"];
    }
    return _ranks1CrownImageView;
}

- (UIImageView *)ranks2CrownImageView {
    if (!_ranks2CrownImageView) {
        _ranks2CrownImageView = [[UIImageView alloc] init];
        _ranks2CrownImageView.image = [UIImage imageNamed:@"rank-2"];
    }
    return _ranks2CrownImageView;
}

- (UIImageView *)ranks3CrownImageView {
    if (!_ranks3CrownImageView) {
        _ranks3CrownImageView = [[UIImageView alloc] init];
        _ranks3CrownImageView.image = [UIImage imageNamed:@"rank-3"];
    }
    return _ranks3CrownImageView;
}

- (UIImageView *)ranks1NoImageView {
    if (!_ranks1NoImageView) {
        _ranks1NoImageView = [[UIImageView alloc] init];
        _ranks1NoImageView.image = [UIImage imageNamed:@"home_rank1"];
    }
    return _ranks1NoImageView;
}

- (UIImageView *)ranks2NoImageView {
    if (!_ranks2NoImageView) {
        _ranks2NoImageView = [[UIImageView alloc] init];
        _ranks2NoImageView.image = [UIImage imageNamed:@"home_rank2"];
    }
    return _ranks2NoImageView;
}

- (UIImageView *)ranks3NoImageView {
    if (!_ranks3NoImageView) {
        _ranks3NoImageView = [[UIImageView alloc] init];
        _ranks3NoImageView.image = [UIImage imageNamed:@"home_rank3"];
    }
    return _ranks3NoImageView;
}

- (UILabel *)ranksTitleLabel {
    if (!_ranksTitleLabel) {
        _ranksTitleLabel = [[UILabel alloc] init];
        _ranksTitleLabel.text = @"魅力人气榜";
        _ranksTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.0];
        _ranksTitleLabel.textAlignment = NSTextAlignmentCenter;
        _ranksTitleLabel.textColor = RGBCOLOR(63, 58, 58);;
    }
    return _ranksTitleLabel;
}

- (UIImageView *)ranksTitleIconImageView {
    if (!_ranksTitleIconImageView) {
        _ranksTitleIconImageView = [[UIImageView alloc] init];
        _ranksTitleIconImageView.image = [UIImage imageNamed:@"icon_rightBtn2"];
    }
    return _ranksTitleIconImageView;
}

- (UILabel *)ranksSubtitleLabel {
    if (!_ranksSubtitleLabel) {
        _ranksSubtitleLabel = [[UILabel alloc] init];
        _ranksSubtitleLabel.text = @"全国人气达人代表大会";
        _ranksSubtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15.0];
        _ranksSubtitleLabel.textAlignment = NSTextAlignmentCenter;
        _ranksSubtitleLabel.textColor = RGBCOLOR(63, 58, 58);;
    }
    return _ranksSubtitleLabel;
}
@end
