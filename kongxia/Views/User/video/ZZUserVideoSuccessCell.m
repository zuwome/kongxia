//
//  ZZUserVideoSuccessCell.m
//  zuwome
//
//  Created by angBiu on 2017/4/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUserVideoSuccessCell.h"
#import "ZZSpreadView.h"

@interface ZZUserVideoSuccessCell ()

@property (nonatomic, strong) ZZUserVideoListModel *model;
@property (nonatomic, strong) ZZSpreadView *spreadView;
@property (nonatomic, strong) UIView *shadowView;

@end

@implementation ZZUserVideoSuccessCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
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
        _imgView.layer.cornerRadius = 3;
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.backgroundColor = kGrayTextColor;
        [bgView addSubview:_imgView];
        
        UIView *coverView = [[UIView alloc] init];
        coverView.backgroundColor = HEXACOLOR(0x000000, 0.4);
        [_imgView addSubview:coverView];
        
        [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_imgView);
        }];
        
        UIImageView *topBgImgView = [[UIImageView alloc] init];
        topBgImgView.image = [UIImage imageNamed:@"icon_rent_topbg"];
        [_imgView addSubview:topBgImgView];
        topBgImgView.alpha = 0.1;
        [topBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(_imgView);
            make.height.mas_equalTo(@50);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.text = @"1000";
        [bgView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
            make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        }];
        
//        _distanceLabel = [[UILabel alloc] init];
//        _distanceLabel.textColor = [UIColor whiteColor];
//        _distanceLabel.font = [UIFont systemFontOfSize:12];
//        _distanceLabel.text = @"7km以内";
//        [self.contentView addSubview:_distanceLabel];
//        
//        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
//            make.centerY.mas_equalTo(_timeLabel.mas_centerY);
//        }];
//
//        _locationImgView = [[UIImageView alloc] init];
//        _locationImgView.image = [UIImage imageNamed:@"icon_rent_location"];
//        [self.contentView addSubview:_locationImgView];
//        
//        [_locationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_distanceLabel.mas_centerY);
//            make.right.mas_equalTo(_distanceLabel.mas_left).offset(-4);
//            make.size.mas_equalTo(CGSizeMake(9, 12));
//        }];
        
        _boomBgImgView = [[UIImageView alloc] init];
        _boomBgImgView.contentMode = UIViewContentModeScaleToFill;
        _boomBgImgView.image = [UIImage imageNamed:@"icon_rent_bottombg"];
        [_imgView addSubview:_boomBgImgView];
        _boomBgImgView.alpha = 0.1;
        [_boomBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(_imgView);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = RGBCOLOR(128, 128, 128);
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 2;
        [bgView addSubview:_contentLabel];
        
        _headImgView = [[ZZHeadImageView alloc] init];
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
            make.bottom.equalTo(@(-10));
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
        
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [self.commentButton setTitleColor:RGBCOLOR(128, 128, 128) forState:UIControlStateNormal];
        [self.commentButton setImage:[UIImage imageNamed:@"btVideoComment"] forState:UIControlStateNormal];
        [self.commentButton addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
        self.commentButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.commentButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [bgView addSubview:self.commentButton];
        [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-10));
            make.trailing.equalTo(@(-8));
            make.width.equalTo(@45);
            make.height.equalTo(@28);
        }];
        
        [_zanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_commentButton.mas_left).offset(-10);
            make.centerY.equalTo(_commentButton);
            make.width.equalTo(@35);
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
    ZZUserVideoListModel *model = (ZZUserVideoListModel *)[notification object];
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
    ZZUserVideoListModel *model = (ZZUserVideoListModel *)[notification object];
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

- (void)setData:(ZZUserVideoListModel *)model
{
    _model = model;

    if (model.sk.id) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:model.sk.video.cover_url]];
        _timeLabel.text = model.sk.created_at_text;
        [_headImgView setUser:model.sk.user width:28 vWidth:8];
        _contentLabel.text = model.sk.content;
        if (!isNullString(model.sk.content)) {
            [UILabel changeLineSpaceForLabel:_contentLabel WithSpace:3.0f];
        }
    } else {
        if (model.mmd.answers.count) {
            ZZMMDAnswersModel *answerModel = model.mmd.answers[0];
            [_imgView sd_setImageWithURL:[NSURL URLWithString:answerModel.video.cover_url]];
        }
        _timeLabel.text = model.mmd.answer_at_text;
        [_headImgView setUser:model.mmd.to width:28 vWidth:8];
        _contentLabel.text = model.mmd.content;
        if (!isNullString(model.mmd.content)) {
            [UILabel changeLineSpaceForLabel:_contentLabel WithSpace:3.0f];
        }
    }
    _zanButton.selected = model.like_status;
}

- (ZZSpreadView *)spreadView
{
    if (!_spreadView) {
        _spreadView = [[ZZSpreadView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
        _spreadView.userInteractionEnabled = NO;
        _spreadView.center = _zanButton.center;
    }
    return _spreadView;
}

#pragma mark - Private methods

- (IBAction)zanClick:(UIButton *)sender {
    if (sender.selected) {
        // 取消赞
        sender.selected = NO;
        [sender setImage:[UIImage imageNamed:@"icon_player_zan_n2"] forState:UIControlStateNormal];
        [self popInsideWithDuration: 0.5];
        
    } else {
        // 赞
        _zanButton.selected = YES;
        [_zanButton setImage:[UIImage imageNamed:@"icon_player_zan_p2"] forState:UIControlStateNormal];
        [self popOutsideWithDuration: 0.5];
        [self.spreadView animate];
    }
    
    BLOCK_SAFE_CALLS(self.zanBlock);
}

- (IBAction)commentClick:(UIButton *)sender {
    BLOCK_SAFE_CALLS(self.commentBlock);
}


- (void)popOutsideWithDuration: (NSTimeInterval) duringTime
{
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
    self.zanButton. transform = CGAffineTransformIdentity;
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
