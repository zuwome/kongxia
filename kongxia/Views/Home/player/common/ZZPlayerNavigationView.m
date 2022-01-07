//
//  ZZPlayNavigationView.m
//  zuwome
//
//  Created by angBiu on 2016/12/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZPlayerNavigationView.h"

#import "ZZLevelImgView.h"
#import "ZZDateHelper.h"

@interface ZZPlayerNavigationView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIImageView *moreImgView;
@property (nonatomic, strong) UIView *zanCountBgView;
@property (nonatomic, strong) UIView *whiteBgView;
@property (nonatomic, strong) UIView *attentBgView;
@property (nonatomic, strong) UIButton *attentBtn;

@property (nonatomic, strong) UILabel *wxLabel;

@property (nonatomic, assign) CGFloat maxWidth;

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSTimeInterval interval;

@end

@implementation ZZPlayerNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height)];
        _bgImgView.image = [UIImage imageNamed:@"icon_rent_topbg"];
        [self addSubview:_bgImgView];
        
        [self addSubview:self.bgView];
        [self addSubview:self.leftBtn];
        self.whiteBgView.hidden = NO;
        [self.moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.zanBtn addTarget:self action:@selector(zanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)setIsBaseVideo:(BOOL)isBaseVideo {
    _isBaseVideo = isBaseVideo;
    if (isBaseVideo) {
        // 如果是查看达人，导航栏不要这些按钮
        self.whiteBgView.hidden = YES;
        self.moreBtn.hidden = YES;
        self.zanBtn.hidden = YES;
        self.headView.hidden = YES;
        self.headView.alpha = 0.0f;
        [self.attentBgView removeAllSubviews];
        [self.attentBgView removeFromSuperview];
        [self.whiteBgView removeFromSuperview];
    }
}


- (void)setLike_status:(BOOL)like_status
{
    self.zanBtn.selected = like_status;
    self.zanTitleLabel.hidden = NO;
}

- (void)setAnimateLikeStatus:(BOOL)animateLikeStatus
{
    self.zanBtn.selected = animateLikeStatus;
    self.zanTitleLabel.hidden = NO;
    [self.zanBtn animate];
}

- (void)setSKData:(ZZSKModel *)model
{
   
    [self.headView setUser:model.user width:36 vWidth:8];
    self.countdownView.hidden = YES;
    [self headHide:NO user:model.user];
    [self setZanCount:model.like_count];

}

- (void)setMMDData:(ZZMMDModel *)model
{
 
    [self.headView setUser:model.to width:36 vWidth:8];
    self.countdownView.hidden = NO;
    if ([model.to.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        ZZMMDAnswersModel *answerModel = model.answers[0];
        if (answerModel.can_re_answer) {
            _interval = [[NSDate date] timeIntervalSinceDate:[[ZZDateHelper shareInstance] getDetailDataWithDateString:answerModel.created_at]];
            if (_interval >= 3600*2) {
                _countdownView.hidden = YES;
            } else {
                _countdownView.hidden = NO;
                
                [_countdownView setTimeInterval:(3600*2 - _interval)];
                
                _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
                dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
                dispatch_source_set_event_handler(_timer, ^{
                    if (_interval == 3600*2) {
                        _countdownView.hidden = YES;
                        answerModel.can_re_answer = NO;
                        dispatch_source_cancel(_timer);
                    }
                    _interval++;
                    [_countdownView setTimeInterval:(3600*2 - _interval)];
                });
                dispatch_resume(_timer);
            }
        } else {
            _countdownView.hidden = YES;
        }
    } else {
        _countdownView.hidden = YES;
    }
    if (!_countdownView.hidden) {
        [self headHide:YES user:model.to];
    } else {
        [self headHide:NO user:model.to];
    }
    [self setZanCount:model.like_count];
//    [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(_maxWidth);
//    }];
}

- (void)headHide:(BOOL)hide user:(ZZUser *)user
{
    _headView.hidden = hide;
    if (user.follow_status == 0 && !hide && ![[ZZUserHelper shareInstance].loginerId isEqualToString:user.uid]) {
        _whiteBgView.hidden = NO;
        [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_maxWidth);
        }];
        _attentBgView.hidden = NO;
    } else {
        [self hideAttentView];
    }
    if ([[ZZUserHelper shareInstance].loginerId isEqualToString:user.uid]) {   //自己微信不显示查看按钮
        _wxLabel.hidden = YES;
    } else {
        if (user.have_wechat_no && ![ZZUserHelper shareInstance].configModel.hide_see_wechat_at_video) {    //有微信且不隐藏
            _wxLabel.hidden = NO;
        } else {
            _wxLabel.hidden = YES;
        }
    }
    _uid = user.uid;
}

- (void)setZanCount:(NSInteger)count
{
    self.zanTitleLabel.hidden = NO;
    _zanTitleLabel.text = [NSString stringWithFormat:@"%ld",count];
    CGFloat width = 14;
    if (count>100) {
        width = [ZZUtils widthForCellWithText:_zanTitleLabel.text fontSize:8] + 5;
    }
    [_zanCountBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

- (void)viewAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        [_whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(36);
        }];
    } completion:^(BOOL finished) {
        _whiteBgView.hidden = YES;
        _attentBgView.hidden = YES;
    }];
}

- (void)hideAttentView
{
    _whiteBgView.hidden = YES;
    _attentBgView.hidden = YES;
}

- (void)showAttentView
{
    [_whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_maxWidth);
    }];
    _whiteBgView.hidden = NO;
    _attentBgView.hidden = NO;
    _headView.hidden = NO;
}

- (void)setViewAlphaScale:(CGFloat)scale
{
    self.bgView.alpha = scale;
    if (scale<0.05) {
        _whiteBgView.backgroundColor = HEXACOLOR(0xffffff, 0.3);
        _leftImgView.image = [UIImage imageNamed:@"icon_rent_left"];
        _moreImgView.image = [UIImage imageNamed:@"icon_player_more_n"];
        _wxLabel.textColor = [UIColor whiteColor];
    } else {
        _whiteBgView.backgroundColor = HEXCOLOR(0xffffff);
        _leftImgView.image = [UIImage imageNamed:@"icon_rent_left"];
        _moreImgView.image = [UIImage imageNamed:@"icon_player_more_n"];
        _wxLabel.textColor = HEXCOLOR(0x3f3a3a);
    }
}

#pragma mark - UIButtonMethod

- (void)leftBtnClick
{
    if (_touchLeft) {
        _touchLeft();
    }
}

- (void)headBtnClick
{
    if (_touchHead) {
        _touchHead();
    }
}

- (void)moreBtnClick
{
    if (_touchMore) {
        _touchMore();
    }
}

- (void)zanBtnClick
{
    if (_touchZan) {
        _touchZan();
    }
}

- (void)attentBtnClick
{
    if (_touchAttent) {
        _touchAttent();
    }
}

- (void)wxBtnClcik
{
    [MobClick event:Event_click_Video_see_wx];
    if (_touchWX) {
        _touchWX(_uid);
    }
}

#pragma mark - Lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
        _bgView.alpha = 0;
        _bgView.clipsToBounds = YES;
        
        if (IOS8_OR_LATER) {
            UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
            effectview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [_bgView addSubview:effectview];
        } else {
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            toolbar.barStyle = UIBarStyleBlackOpaque;
            [_bgView addSubview:toolbar];
        }
    }
    return _bgView;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 45, 44)];
        _leftBtn.bottom = self.bottom - 5;
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _leftImgView = [[UIImageView alloc] init];
        _leftImgView.userInteractionEnabled = NO;
        _leftImgView.image = [UIImage imageNamed:@"icon_rent_left"];
        _leftImgView.contentMode = UIViewContentModeLeft;
        [_leftBtn addSubview:_leftImgView];
        
        [_leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_leftBtn.mas_left).offset(15);
            make.top.bottom.right.mas_equalTo(_leftBtn);
        }];
    }
    return _leftBtn;
}

- (UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [self addSubview:_moreBtn];
        
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_leftBtn.mas_right);
            make.centerY.mas_equalTo(_leftBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(45, 50));
        }];
        
        _moreImgView = [[UIImageView alloc] init];
        _moreImgView.userInteractionEnabled = NO;
        _moreImgView.image = [UIImage imageNamed:@"icon_player_more_n"];
        [_moreBtn addSubview:_moreImgView];
        
        [_moreImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_moreBtn.mas_centerX);
            make.centerY.mas_equalTo(_moreBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    
    return _moreBtn;
}

- (ZZSpreadButton *)zanBtn
{
    if (!_zanBtn) {
        _zanBtn = [[ZZSpreadButton alloc] init];
        [_zanBtn setImage:[UIImage imageNamed:@"icon_player_zan_n"] forState:UIControlStateNormal];
        [_zanBtn setImage:[UIImage imageNamed:@"icon_player_zan_p"] forState:UIControlStateSelected];
        [self addSubview:_zanBtn];
        
        [_zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_moreBtn.mas_right);
            make.centerY.mas_equalTo(_moreBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(45, 50));
        }];
        
        _zanBtn.imageSize = CGSizeMake(21, 21);

        _zanCountBgView = [[UIView alloc] init];
        _zanCountBgView.backgroundColor = [UIColor whiteColor];
        _zanCountBgView.layer.cornerRadius = 7;
        _zanCountBgView.userInteractionEnabled = NO;
        [_zanBtn addSubview:_zanCountBgView];
        
        [_zanCountBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_zanBtn.mas_centerX).offset(9);
            make.centerY.mas_equalTo(_zanBtn.mas_centerY).offset(-14);
            make.height.mas_equalTo(@14);
        }];
        
        _zanTitleLabel = [[UILabel alloc] init];
        _zanTitleLabel.textAlignment = NSTextAlignmentCenter;
        _zanTitleLabel.textColor = HEXCOLOR(0x3F3A3A);
        _zanTitleLabel.font = [UIFont systemFontOfSize:8];
        _zanTitleLabel.text = @"0";
        _zanTitleLabel.hidden = YES;
        [_zanCountBgView addSubview:_zanTitleLabel];
        
        [_zanTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_zanCountBgView.mas_centerY);
            make.centerX.mas_equalTo(_zanCountBgView.mas_centerX);
        }];
    }
    return _zanBtn;
}

- (ZZHeadImageView *)headView
{
    WeakSelf;
    if (!_headView) {
        _headView = [[ZZHeadImageView alloc] init];
        [self addSubview:_headView];
        
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.centerY.mas_equalTo(_leftBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        _headView.touchHead = ^{
            [weakSelf headBtnClick];
        };
    }
    return _headView;
}

- (UIView *)whiteBgView
{
    if (!_whiteBgView) {
        CGFloat width = [ZZUtils widthForCellWithText:@"关注" fontSize:12] + 12;
        _maxWidth = width + 6 + 10 + 36;
        
        _whiteBgView = [[UIView alloc] init];
        _whiteBgView.backgroundColor = HEXACOLOR(0xffffff, 0.3);
        _whiteBgView.layer.cornerRadius = 18;
        [self addSubview:_whiteBgView];
        
        [_whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_leftBtn.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(_maxWidth, 36));
        }];
        
        _attentBgView = [[UIView alloc] init];
        _attentBgView.backgroundColor = kYellowColor;
        _attentBgView.layer.cornerRadius = 13;
        _attentBgView.userInteractionEnabled = NO;
        [self addSubview:_attentBgView];
        
        [_attentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_whiteBgView.mas_left).offset(6);
            make.centerY.mas_equalTo(_whiteBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(width, 26));
        }];
        
        UILabel *attentLabel = [[UILabel alloc] init];
        attentLabel.textColor = HEXCOLOR(0x3f3a3a);
        attentLabel.font = [UIFont systemFontOfSize:12];
        attentLabel.text = @"关注";
        [_attentBgView addSubview:attentLabel];
        
        [attentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(_attentBgView);
        }];
        
        _attentBtn = [[UIButton alloc] init];
        [_attentBtn addTarget:self action:@selector(attentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_whiteBgView addSubview:_attentBtn];
        
        [_attentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(_whiteBgView);
            make.width.mas_equalTo(_maxWidth-36);
        }];
    }
    return _whiteBgView;
}

- (ZZVideoCountdownView *)countdownView
{
    WeakSelf;
    if (!_countdownView) {
        _countdownView = [[ZZVideoCountdownView alloc] init];
        _countdownView.hidden = YES;
        [self addSubview:_countdownView];
        
        [_countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-8);
            make.centerY.mas_equalTo(_headView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(90, 52));
        }];
        
        _countdownView.touchRecord = ^{
            if (weakSelf.touchRecord) {
                weakSelf.touchRecord();
            }
        };
    }
    return _countdownView;
}

@end
