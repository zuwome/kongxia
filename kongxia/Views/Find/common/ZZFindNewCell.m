//
//  ZZFindNewCell.m
//  zuwome
//
//  Created by angBiu on 16/8/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZFindNewCell.h"
#import "ZZSpreadView.h"
#import "ZZMemedaModel.h"
#import "ZZCornerRadiuImageView.h"

@interface ZZFindNewCell ()

@property (nonatomic, strong) ZZSpreadView *spreadView;
@property (nonatomic, strong) UIView *shadowView;

@end

@implementation ZZFindNewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
//        self.contentView.layer.masksToBounds = YES;
//        self.contentView.layer.cornerRadius = 3.0f;
        
        self.shadowView = [UIView new];
        self.shadowView.backgroundColor = RGBCOLOR(190, 190, 190);
        _shadowView.layer.shadowColor = RGBCOLOR(190, 190, 190).CGColor;//阴影颜色
        _shadowView.layer.shadowOffset = CGSizeMake(0, 2);//偏移距离
        _shadowView.layer.shadowOpacity = 0.5;//不透明度
        _shadowView.layer.shadowRadius = 2.0f;
        _shadowView.layer.cornerRadius = 3.0f;
        [self.contentView addSubview:self.shadowView];
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];

        UIView *bgView = [[UIView alloc] init];
        bgView.clipsToBounds = YES;
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 3.0f;

        [self.contentView addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];

        _imgView = [[UIImageView alloc] init];
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.backgroundColor = kGrayTextColor;
        [bgView addSubview:_imgView];
        
        
//        UIImageView *topBgImgView = [[UIImageView alloc] init];
//        topBgImgView.image = [UIImage imageNamed:@"icon_rent_topbg"];
//        [bgView addSubview:topBgImgView];
//
//        [topBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.mas_equalTo(bgView);
//            make.height.mas_equalTo(@50);
//        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = RGBCOLOR(128, 128, 128);
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 2;
        [bgView addSubview:_contentLabel];
        
        _headImgView = [[ZZCornerRadiuImageView alloc] initWithFrame:CGRectZero headerImageWidth:28];
        [bgView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@10);
            make.bottom.equalTo(@(-10));
            make.width.height.equalTo(@30);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imgView.mas_bottom).offset(10);
            make.leading.equalTo(@10);
            make.trailing.equalTo(@(-10));
            make.bottom.lessThanOrEqualTo(_headImgView.mas_top).offset(-10);
        }];

        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.equalTo(@0);
            make.bottom.lessThanOrEqualTo(_contentLabel.mas_top).offset(-10);
        }];

        [bgView addSubview:self.spreadView];
        [self.spreadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(-9);
            make.centerY.equalTo(_headImgView.mas_centerY);
            make.width.height.equalTo(@13);
        }];

        _zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zanButton setTitle:@"赞" forState:UIControlStateNormal];
        [_zanButton setTitleColor:RGBCOLOR(128, 128, 128) forState:UIControlStateNormal];
        [_zanButton setImage:[UIImage imageNamed:@"icon_player_zan_n2"] forState:UIControlStateNormal];
        [_zanButton setImage:[UIImage imageNamed:@"icon_player_zan_p2"] forState:UIControlStateSelected];
        [_zanButton addTarget:self action:@selector(zanClick:) forControlEvents:UIControlEventTouchUpInside];
        _zanButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _zanButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:_zanButton];
        [_zanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView);
            make.centerY.equalTo(_headImgView.mas_centerY);
            make.width.equalTo(@35);
            make.height.equalTo(@28);
        }];
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [self.commentButton setTitleColor:RGBCOLOR(128, 128, 128) forState:UIControlStateNormal];
        [self.commentButton setImage:[UIImage imageNamed:@"btVideoComment"] forState:UIControlStateNormal];
        [self.commentButton addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
        self.commentButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.commentButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [bgView addSubview:self.commentButton];
        [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headImgView.mas_centerY);
            make.trailing.equalTo(@(-8));
            make.width.equalTo(@45);
            make.height.equalTo(@28);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skDidChange:) name:kMsg_SK_Zan_Status object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mmdDidChange:) name:kMsg_MMD_Zan_Status object:nil];
    }
    
    return self;
}

#pragma mark - NotificationCenter
//赞发生变化
- (void)skDidChange:(NSNotification *)notification {
    ZZFindVideoModel *model = (ZZFindVideoModel *)[notification object];
    if ([model.sk.id isEqualToString:_model.sk.id]) {
        if (model.like_status) {
            // 赞
            _zanButton.selected = YES;
        } else {
            // 取消赞
            _zanButton.selected = NO;
        }
    }
}

- (void)mmdDidChange:(NSNotification *)notification {
    ZZFindVideoModel *model = (ZZFindVideoModel *)[notification object];
    if ([model.mmd.mid isEqualToString:_model.mmd.mid]) {
        if (model.like_status) {
            // 赞
            _zanButton.selected = YES;
        } else {
            // 取消赞
            _zanButton.selected = NO;
        }
    }
}

- (void)setMMDData:(ZZFindVideoModel *)model {
    _model = model;
    [self.imgView removeAllSubviews];
    ZZMMDAnswersModel *answerModel = model.mmd.answers[0];
    //SDWebImageContinueInBackground SDWebImageLowPriority
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:answerModel.video.cover_url] placeholderImage:nil options:SDWebImageContinueInBackground progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        model.isHaveVideo = YES;
    }];
    [self.headImgView setUser:model.mmd.to width:+28 vWidth:6];
    self.contentLabel.text = model.mmd.content;
    //赞数
//    self.zanCountLabel.text = [NSString stringWithFormat:@"%ld",model.mmd.like_count];
//    if (model.like_status) {
//        _zanImgView.image = [UIImage imageNamed:@"icon_player_zan_p"];
//    } else {
//        _zanImgView.image = [UIImage imageNamed:@"icon_player_zan_n"];
//    }
    if (!isNullString(model.mmd.content)) {
//        [UILabel changeLineSpaceForLabel:_contentLabel WithSpace:3.0f];
    }
    _zanButton.selected = model.like_status;
}

- (void)setSkData:(ZZFindVideoModel *)videModel {
    _model = videModel;
//    [self.imgView removeAllSubviews];
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:videModel.sk.video.cover_url] placeholderImage:nil options:SDWebImageContinueInBackground];

    [self.headImgView setUser:videModel.sk.user width:+28 vWidth:6];
    self.contentLabel.text = videModel.sk.content;
    //赞数
//    self.zanCountLabel.text = [NSString stringWithFormat:@"%ld",videModel.sk.like_count];
//    if (videModel.like_status) {
//        _zanImgView.image = [UIImage imageNamed:@"icon_player_zan_p"];
//    } else {
//        _zanImgView.image = [UIImage imageNamed:@"icon_player_zan_n"];
//    }
    if (!isNullString(videModel.sk.content)) {
//        [UILabel changeLineSpaceForLabel:_contentLabel WithSpace:3.0f];
    }
    _zanButton.selected = videModel.like_status;
}

- (ZZSpreadView *)spreadView {
    if (!_spreadView) {
        _spreadView = [[ZZSpreadView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
        _spreadView.userInteractionEnabled = NO;
        CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        _spreadView.center = CGPointMake(size.width/2.0, size.height/2.0);
    }
    return _spreadView;
}

#pragma mark - Private methods

- (IBAction)zanClick:(UIButton *)sender {
    if (sender.selected) {
        // 取消赞
        sender.selected = NO;
        [self popInsideWithDuration: 0.5];

    } else {
        // 赞
        _zanButton.selected = YES;
        [self popOutsideWithDuration: 0.5];
        [self.spreadView animate];
    }
    
    BLOCK_SAFE_CALLS(self.zanBlock);
}

- (IBAction)commentClick:(UIButton *)sender {
    BLOCK_SAFE_CALLS(self.commentBlock);
}

- (void)popOutsideWithDuration: (NSTimeInterval) duringTime {
    self.zanButton.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration: duringTime delay: 0 options: 0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime: 0
                                relativeDuration: 1 / 3.0
                                      animations: ^{
                                          self.zanButton.imageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                      }];
        [UIView addKeyframeWithRelativeStartTime: 1 / 3.0
                                relativeDuration: 1 / 3.0
                                      animations: ^{
                                          self.zanButton.imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                                      }];
        [UIView addKeyframeWithRelativeStartTime: 2 / 3.0
                                relativeDuration: 1 / 3.0
                                      animations: ^{
                                          self.zanButton.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                      }];
    } completion: ^(BOOL finished) {
        
    }];
}

- (void)popInsideWithDuration: (NSTimeInterval) duringTime
{
    self.zanButton.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration: duringTime delay: 0 options: 0 animations: ^{\
        [UIView addKeyframeWithRelativeStartTime: 0
                                relativeDuration: 1 / 2.0
                                      animations: ^{
                                          self.zanButton.imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                                      }];
        [UIView addKeyframeWithRelativeStartTime: 1 / 2.0
                                relativeDuration: 1 / 2.0
                                      animations: ^{
                                          self.zanButton.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                      }];
    } completion: ^(BOOL finished) {
        
    }];
}
@end
