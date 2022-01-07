//
//  ZZKTVSingingTaskCompleteCell.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/15.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVSingingTaskCompleteCell.h"
#import "ZZKTVConfig.h"
#import <FLAnimatedImage.h>
#import <FLAnimatedImageView.h>
@interface ZZKTVSingingTaskCompleteCell ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *userIconImageView;

@property (nonatomic, strong) UILabel *singingTipsLabel;

@property (nonatomic, strong) UIButton *singBtn;

@property (nonatomic, strong) UIImageView *playingImageView;

@property (nonatomic, strong) UILabel *playingTitleLabel;

@property (nonatomic, strong) FLAnimatedImageView *playingIconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIButton *postTaskBtn;

@end

@implementation ZZKTVSingingTaskCompleteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    if (_taskDetailModel.task.is_anonymous == 2) {
        [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:_taskDetailModel.task.anonymous_avatar] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIImage *roundImage = [image imageAddCornerWithRadius:45 andSize:CGSizeMake(90, 90)];
            _userIconImageView.image = roundImage;
        }];
    }
    else {
        [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:[_taskDetailModel.task.from displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIImage *roundImage = [image imageAddCornerWithRadius:45 andSize:CGSizeMake(90, 90)];
            _userIconImageView.image = roundImage;
        }];
    }
    
    _singingTipsLabel.text = [NSString stringWithFormat:@"唱歌成功可领取TA一个%@", _taskDetailModel.task.gift.name];
    
    if (_taskDetailModel.receiveStatus == 1) {
        __block BOOL didFinishlate = NO;
        [_taskDetailModel.receiveList enumerateObjectsUsingBlock:^(ZZKTVReceiveUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.to.uid isEqualToString: [ZZUserHelper shareInstance].loginer.uid] && isNullString(obj.gift_recording)) {
                didFinishlate = YES;
                *stop = YES;
            }
        }];
        
        if (didFinishlate) {
            _titleLabel.text = @"来晚了！";
            _subTitleLabel.text = @"礼物刚刚已被领取完，下次要早点来参与哦！";

        }
        else {
            _titleLabel.text = @"领取成功！";
            _subTitleLabel.text = [NSString stringWithFormat:@"礼物收益%.2f元", _taskDetailModel.task.gift.price * _taskDetailModel.gift_rate];
        }
        _singBtn.selected = _taskDetailModel.isPlaying;
        
        if (_taskDetailModel.isPlaying) {
            _singBtn.hidden = YES;
            self.playingImageView.hidden = NO;
        }
        else {
            _singBtn.hidden = NO;
            self.playingImageView.hidden = YES;
        }
        
        [_singBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_subTitleLabel.mas_bottom).offset(51.0);
        }];
        
        [_postTaskBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_singBtn.mas_bottom).offset(20.0);
        }];
    }
    else if (_taskDetailModel.areGiftsAllCollected) {
        _titleLabel.text = @"来晚了！";
        _subTitleLabel.text = @"礼物刚刚已被领取完，下次要早点来参与哦！";
        _singBtn.hidden = YES;
        
        [_postTaskBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_subTitleLabel.mas_bottom).offset(41.0);
        }];
    }
}


#pragma mark - response method
- (void)stopPlaying {
    if (self.delegate && [self.delegate respondsToSelector:@selector(comepleteCellStartToPlay:)]) {
        [self.delegate comepleteCellStartToPlay:self];
    }
}

- (void)startPlayAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(comepleteCellStartToPlay:)]) {
        [self.delegate comepleteCellStartToPlay:self];
    }
}

- (void)postTask {
    if (self.delegate && [self.delegate respondsToSelector:@selector(comepleteCellGoPostTask:)]) {
        [self.delegate comepleteCellGoPostTask:self];
    }
}

- (void)showUserInfo {
    if (_taskDetailModel.task.is_anonymous == 2) {
        [ZZHUD showTaskInfoWithStatus:@"该用户已匿名"];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(completeCell:showTaskOwner:)]) {
        [self.delegate completeCell:self showTaskOwner:_taskDetailModel];
    }
}


#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(54, 54, 54);
    self.clipsToBounds = YES;
    
    [self addSubview:self.bgImageView];
    [self addSubview:self.userIconImageView];
    [self addSubview:self.singingTipsLabel];
    [self addSubview:self.singBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.postTaskBtn];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.left.right.equalTo(self);
    }];
    
    [_userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(50.0);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    [_singingTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_userIconImageView.mas_bottom).offset(10.0);
        make.left.right.equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(50.0);
        make.right.equalTo(self).offset(-50.0);
        make.top.equalTo(_singingTipsLabel.mas_bottom).offset(36.0);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_titleLabel.mas_bottom).offset(5.0);
        make.left.equalTo(self).offset(30.0);
        make.right.equalTo(self).offset(-30.0);
    }];
    
    [_singBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(67, 67));
        make.top.equalTo(_subTitleLabel.mas_bottom).offset(51.0);
    }];
    
    [_postTaskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(104, 32));
        make.top.equalTo(_singBtn.mas_bottom).offset(20.0);
        make.bottom.equalTo(self).offset(-32);
    }];
}


#pragma mark - getters and setters
- (void)setTaskDetailModel:(ZZKTVDetailsModel *)taskDetailModel {
    _taskDetailModel = taskDetailModel;
    [self configureData];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"bgChangpaxiangqing"];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

- (UILabel *)singingTipsLabel {
    if (!_singingTipsLabel) {
        _singingTipsLabel = [[UILabel alloc] init];
        _singingTipsLabel.text = @"唱歌成功可领取TA一个";
        _singingTipsLabel.font = ADaptedFontMediumSize(15);
        _singingTipsLabel.textColor = RGBCOLOR(244, 203, 7);
        _singingTipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _singingTipsLabel;
}

- (UIImageView *)userIconImageView {
    if (!_userIconImageView) {
        _userIconImageView = [[UIImageView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
        [_userIconImageView addGestureRecognizer:tap];
        _userIconImageView.userInteractionEnabled = YES;
    }
    return _userIconImageView;
}

- (UIButton *)singBtn {
    if (!_singBtn) {
        _singBtn = [[UIButton alloc] init];
        _singBtn.backgroundColor = kGoldenRod;
        _singBtn.layer.cornerRadius = 67 / 2;
        _singBtn.normalImage = [UIImage imageNamed:@"icBofang"];
        _singBtn.selectedImage = [UIImage imageNamed:@""];
        [_singBtn addTarget:self action:@selector(startPlayAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _singBtn;
}

- (UIImageView *)playingImageView {
    if (!_playingImageView) {
        _playingImageView = [[UIImageView alloc] init];
        _playingImageView.image = [UIImage imageNamed:@"ktv_playing_bg"];
        _playingImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopPlaying)];
        [_playingImageView addGestureRecognizer:tap];
        
        
        _playingTitleLabel = [[UILabel alloc] init];
        _playingTitleLabel.text = @"停止";
        _playingTitleLabel.font = ADaptedFontMediumSize(11.0);
        _playingTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _playingTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_playingImageView addSubview:_playingTitleLabel];
        
        _playingIconImageView = [[FLAnimatedImageView alloc] init];
        NSURL *gifLocalUrl = [[NSBundle mainBundle] URLForResource:@"KTV_PlayAudio" withExtension:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfURL:gifLocalUrl];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
        _playingIconImageView.animatedImage = image;
        [_playingImageView addSubview:_playingIconImageView];
        
        [_playingTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_playingImageView);
            make.bottom.equalTo(_playingImageView).offset(-9);
        }];
        
        [_playingIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_playingImageView);
            make.bottom.equalTo(_playingTitleLabel.mas_top).offset(-2);
            make.size.mas_equalTo(CGSizeMake(35, 26));
        }];
        
        [self addSubview:_playingImageView];
        [_playingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(67, 67));
            make.top.equalTo(_subTitleLabel.mas_bottom).offset(51.0);
        }];
    }
    return _playingImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"来晚了！";
        _titleLabel.font = ADaptedFontSCBoldSize(19.0);
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.text = @"礼物刚刚已被领取完，下次要早点来参与哦！";
        _subTitleLabel.font = ADaptedFontMediumSize(16.0);
        _subTitleLabel.textColor = RGBACOLOR(255, 255, 255, 0.8);
        _subTitleLabel.numberOfLines = 2;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLabel;
}

- (UIButton *)postTaskBtn {
    if (!_postTaskBtn) {
        _postTaskBtn = [[UIButton alloc] init];
        _postTaskBtn.normalTitle = @"我也要发";
        _postTaskBtn.normalTitleColor = RGBACOLOR(244, 203, 7, 0.8);
        _postTaskBtn.titleLabel.font = ADaptedFontMediumSize(15.0);
        _postTaskBtn.layer.cornerRadius = 16.0;
        _postTaskBtn.layer.borderColor = RGBACOLOR(244, 203, 7, 0.8).CGColor;
        _postTaskBtn.layer.borderWidth = 1;
        [_postTaskBtn addTarget:self action:@selector(postTask) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postTaskBtn;
}

@end
 
