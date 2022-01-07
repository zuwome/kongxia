//
//  ZZNewHomeSubjectCellItem.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/21.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewHomeSubjectCellItem.h"
#import "VideoPlayer.h"
#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>

@interface ZZNewHomeSubjectCellItem () <JPVideoPlayerDelegate>

@property (nonatomic, strong) UIImageView *subjectImage;
@property (nonatomic, strong) UIImageView *titleMask;
@property (nonatomic, strong) UILabel *subjectTitle;
@property (nonatomic, strong) UIImageView *videoIcon;
@property (nonatomic, strong) FLAnimatedImageView *gifImage;

@end

@implementation ZZNewHomeSubjectCellItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(specialTopicClick)]];
    
    [self addSubview:self.subjectImage];
    [self addSubview:self.gifImage];
    [self addSubview:self.videoIcon];
    [self addSubview:self.titleMask];
    [self addSubview:self.subjectTitle];
    [_subjectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_gifImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.videoIcon.hidden = YES;
    [_videoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_subjectTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@5);
        make.trailing.bottom.equalTo(@-5);
    }];
    
    [_titleMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(_subjectTitle).offset(-5);
        make.bottom.trailing.equalTo(_subjectTitle).offset(5);
    }];
}

- (void)setCornerRadio:(CGFloat)cornerRadio {
    _cornerRadio = cornerRadio;
    self.layer.cornerRadius = cornerRadio;
    self.clipsToBounds = YES;
}

- (void)setShowVideoIcon:(BOOL)showVideoIcon {
    _showVideoIcon = [self isVideo] ? NO : YES;
    self.videoIcon.hidden = [self isVideo] ? NO : YES;
}

- (void)setModel:(ZZHomeSpecialTopicModel *)model {
    _model = model;
    self.subjectTitle.text = model.name;
    if (model.type == 3) {
        self.gifImage.hidden = NO;
        self.subjectImage.hidden = YES;
        FLAnimatedImage *img = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.cover]]];
        self.gifImage.animatedImage = img;
    } else {
        self.gifImage.hidden = YES;
        self.subjectImage.hidden = NO;
        [self.subjectImage sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    }
}

- (void)specialTopicClick {
    !self.specialTopicCallback ? : self.specialTopicCallback(self.model);
}

- (BOOL)isVideo {
    //1、h5 ;2、图片；3、视频
    return self.model.type == 3 ? YES : NO;
}

- (void)videoPlay {
    if (self.isPlaying) {   //正在播放
        return ;
    }
    self.isPlaying = YES;
}

- (void)videoStop {
    if (!self.isPlaying) {  //停止播放
        return ;
    }
    self.isPlaying = NO;
//    [self jp_stopPlay];
}

- (UIImageView *)videoIcon {
    if (nil == _videoIcon) {
        _videoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icHomeVideo"]];
    }
    return _videoIcon;
}

- (UIImageView *)titleMask {
    if (nil == _titleMask) {
        _titleMask = [[UIImageView alloc] init];
        _titleMask.image = [UIImage imageNamed:@"icSpecialTopicMask"];
    }
    return _titleMask;
}

- (UILabel *)subjectTitle {
    if (nil == _subjectTitle) {
        _subjectTitle = [[UILabel alloc] init];
        _subjectTitle.textColor = [UIColor whiteColor];
        _subjectTitle.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
        _subjectTitle.numberOfLines = 2;
    }
    return _subjectTitle;
}

- (UIImageView *)subjectImage {
    if (nil == _subjectImage) {
        _subjectImage = [[UIImageView alloc] init];
        _subjectImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _subjectImage;
}

- (FLAnimatedImageView *)gifImage {
    if (nil == _gifImage) {
        _gifImage = [[FLAnimatedImageView alloc] init];
        _gifImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _gifImage;
}

@end
