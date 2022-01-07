//
//  ZZChatKTVCell.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/16.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZChatKTVCell.h"
#import "ZZChatKTVModel.h"
#import <FLAnimatedImage.h>
#import <FLAnimatedImageView.h>

@interface ZZChatKTVCell ()

@property (nonatomic, strong) FLAnimatedImageView *playingGifImageView;

@property (nonatomic, strong) UIImageView *ktvBgImageView;

@property (nonatomic, strong) UIView *playView;

@property (nonatomic, strong) UILabel *playLabel;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UILabel *desLabel;

@property (nonatomic, strong) ZZChatKTVModel *ktvModel;

@end

@implementation ZZChatKTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}


- (void)setData:(ZZChatBaseModel *)model {
    [super setData:model];
    RCMessage *message = model.message;
    
    // 重新布局
    [self relayout:message.messageDirection == MessageDirection_SEND];
    
    ZZChatKTVModel *ktvMessage = (ZZChatKTVModel *)message.content;
    _ktvModel = ktvMessage;
    BOOL inReverse = NO;
    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
    if (message.messageDirection == MessageDirection_SEND) {
        corners = UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight;
        inReverse = NO;
    }
    else {
        corners = UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
        inReverse = YES;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.ktvBgImageView.bounds byRoundingCorners: corners cornerRadii:CGSizeMake(10.0, 10.0)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        self.ktvBgImageView.layer.mask = shape;
    });
    
    _desLabel.text = ktvMessage.songStatus;
    
    NSString *fileName = [[ktvMessage.songUrl stringByDeletingPathExtension] stringByDeletingPathExtension];
    NSArray *componentsArr = [fileName componentsSeparatedByString:@"_"];
    if (componentsArr.count == 3) {
        _playLabel.text = [NSString stringWithFormat:@"%@″", componentsArr.lastObject];
    }
    
    _playBtn.selected = ktvMessage.isSongPlaying;
    if (ktvMessage.isSongPlaying) {
        [self showPlayingAnimation];
    }
    else {
        [self hidePlayingAnimation];
    }
}


#pragma mark - response method
- (void)playAudio {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:playSong:)]) {
        [self.delegate cell:self playSong:_ktvModel];
    }
}


#pragma mark - Layout
- (void)layout {
    [self.bgView addSubview:self.ktvBgImageView];
    [self.bgView addSubview:self.playView];
    [_playView addSubview:self.playBtn];
    [_playView addSubview:self.playLabel];
    
    [self.bgView addSubview:self.desLabel];
    
    [_playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_ktvBgImageView).offset(10.0);
        make.right.equalTo(_ktvBgImageView).offset(-10.0);
        make.height.equalTo(@36);
    }];
    
    [_playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_playView);
        make.left.equalTo(_playView).offset(10.0);
    }];
    
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_playView);
        make.right.equalTo(_playView).offset(-7.0);
    }];
    
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ktvBgImageView).offset(10.0);
        make.right.equalTo(_ktvBgImageView).offset(-10.0);
        make.top.equalTo(_playView.mas_bottom).offset(6);
    }];
}

- (void)relayout:(BOOL)isSend {
    self.bubbleImgView.image = nil;
    
    if (isSend) {
        [_ktvBgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@204);
            make.edges.equalTo(self.bgView);
        }];
        
//        _playView.hidden = YES;
//        [_desLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_ktvBgImageView).offset(10);
//        }];
    }
    else {
        [_ktvBgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@204);
            make.edges.equalTo(self.bgView);
        }];
        
//        _playView.hidden = NO;
//        [_desLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_playView.mas_bottom).offset(6);
//        }];
    }
}

- (void)showPlayingAnimation {
    [_playView addSubview:self.playingGifImageView];
    [_playingGifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_playView);
        make.left.equalTo(_playLabel.mas_right).offset(10.0);
        make.size.mas_equalTo(CGSizeMake(90, 27));
    }];
}

- (void)hidePlayingAnimation {
    [_playingGifImageView removeFromSuperview];
    _playingGifImageView = nil;
}

#pragma mark - getters and setters
- (UIImageView *)ktvBgImageView {
    if (!_ktvBgImageView) {
        _ktvBgImageView = [[UIImageView alloc] init];
        _ktvBgImageView.userInteractionEnabled = YES;
        _ktvBgImageView.backgroundColor = UIColor.randomColor;
        _ktvBgImageView.image = [UIImage imageNamed:@"picBeijingBofang"];
        _ktvBgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _ktvBgImageView;
}

- (UIView *)playView {
    if (!_playView) {
        _playView = [[UIView alloc] init];
        _playView.backgroundColor = RGBCOLOR(255, 243, 230);
        _playView.layer.cornerRadius = 2;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAudio)];
        [_playView addGestureRecognizer:tap];
    }
    return _playView;
}

- (UILabel *)playLabel {
    if (!_playLabel) {
        _playLabel = [[UILabel alloc] init];
        _playLabel.text = @"0″";
        _playLabel.font = ADaptedFontMediumSize(12);
        _playLabel.textColor = RGBCOLOR(250, 77, 46);
        _playLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _playLabel;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        _playBtn.normalTitle = @"开始";
        _playBtn.selectedTitle = @"停止";
        _playBtn.normalTitleColor = RGBCOLOR(250, 77, 46);
        _playBtn.titleLabel.font = ADaptedFontMediumSize(12);
        _playBtn.normalImage = [UIImage imageNamed:@"SongPlayBtn"];
        _playBtn.selectedImage = [UIImage imageNamed:@"icTingzhi"];
        _playBtn.userInteractionEnabled = NO;
        [_playBtn setImagePosition:LXMImagePositionRight spacing:2];
    }
    return _playBtn;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.text = @"嗨！谢谢你的礼物，这是我的唱趴任务！";
        _desLabel.font = ADaptedFontMediumSize(12);
        _desLabel.textColor = RGBACOLOR(255, 255, 255, 0.8);
        _desLabel.numberOfLines = 2;
    }
    return _desLabel;
}

- (FLAnimatedImageView *)playingGifImageView {
    if (!_playingGifImageView) {
        _playingGifImageView = [[FLAnimatedImageView alloc] init];
        NSURL *gifLocalUrl = [[NSBundle mainBundle] URLForResource:@"KTV_ChatPlaying" withExtension:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfURL:gifLocalUrl];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
        _playingGifImageView.animatedImage = image;
        _playingGifImageView.userInteractionEnabled = NO;
        [_playingGifImageView stopAnimating];
        
    }
    return _playingGifImageView;
}

@end
