//
//  ZZCommissionShareToastView.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCommissionShareToastView.h"
#import <UMSocialCore/UMSocialCore.h>

#import "ZZCommissionShareView.h"

#import "CommissionConfig.h"
#import "ZZCommossionManager.h"
#import "ZZCommissionModel.h"

@interface ZZCommissionShareToastView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView   *contentView;

@property (nonatomic, strong) UIImageView *titleImageView;

@property (nonatomic, strong) UIImageView *titleLeftImageView;

@property (nonatomic, strong) UIImageView *titleRightImageView;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UILabel *bottomTitleLabel;

@property (nonatomic, strong) ZZCommissionModel *model;

@property (nonatomic, strong) ZZCommissionShareToastDoubleCheckView *doubleCheckView;

@end


@implementation ZZCommissionShareToastView

+ (void)show {
    ZZCommissionShareToastView *view = [[ZZCommissionShareToastView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    [view show];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}


#pragma mark private method
- (void)close {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.0;
        _doubleCheckView.top = self.height;
    } completion:^(BOOL finished) {
        [_doubleCheckView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.5;
        _contentView.top = self.height * 0.5 - _contentView.height * 0.5;
    }];
}

- (void)showDoubleCheckView {
    _contentView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.doubleCheckView.top = self.height / 2 - self.doubleCheckView.height / 2;
    } completion:^(BOOL finished) {
        [_contentView removeFromSuperview];
        _contentView = nil;
    }];
}

#pragma mark response method
- (void)closeAction {
    [self showDoubleCheckView];
}

- (void)doubleCheckCloseAction {
    [self close];
}

- (void)share:(UITapGestureRecognizer *)recognizer {
    
    CommissionChannel channel = (CommissionChannel)recognizer.view.tag;

    if (!_model) {
        [[ZZCommossionManager manager] fetchInviteCodeInfos:^(BOOL isSuccess, ZZCommissionModel *commissionModel) {
            if (isSuccess && commissionModel) {
                _model = commissionModel;
                [self createShareSnapChatView:channel];
            }
        }];
    }
    else {
        [self createShareSnapChatView:channel];
    }
}

- (void)createShareSnapChatView:(CommissionChannel)channel {
    ZZCommissionShareView *view = [[ZZCommissionShareView alloc] initWithInfoModel:_model
                                                                             frame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT) entry:CommissionChannelEntryMyCommission];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    UIImage *image = [view cutFromView:view];
    [view removeFromSuperview];
    view = nil;
    if (image) {
        [ZZHUD dismiss];
    }
    else {
        [ZZHUD showErrorWithStatus:@"分享失败"];
        return;
    }
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    if (channel == CommissionChannelLink) {
        // 分享链接
        NSMutableString *shareContent = [_model.tip.tixian_text[@"content"] mutableCopy];
        NSRange range = [shareContent rangeOfString:@"空虾用户名"];
        if (range.location != NSNotFound) {
            [shareContent replaceCharactersInRange:range withString:[ZZUserHelper shareInstance].loginer.nickname];
        }
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_model.tip.tixian_text[@"title"] descr:shareContent.copy thumImage:[UIImage imageNamed:@"kongxialogo"]];
        shareObject.webpageUrl = _model.inviteURL;
        messageObject.shareObject = shareObject;
    }
    else {
        // 分享图片
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        shareObject.thumbImage = [UIImage imageNamed:@"kongxialogo"];
        [shareObject setShareImage:image];
        messageObject.shareObject = shareObject;
    }
    
    UMSocialPlatformType type;
    switch (channel) {
        case CommissionChannelMoments: {
            type = UMSocialPlatformType_WechatTimeLine;
            break;
        }
        case CommissionChannelWechat: {
            type = UMSocialPlatformType_WechatSession;
            break;
        }
        case CommissionChannelLink: {
            type = UMSocialPlatformType_WechatSession;
            break;
        }
        default:
            type = UMSocialPlatformType_UnKnown;
            break;
    }

    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:[UIViewController currentDisplayViewController] completion:^(id result, NSError *error) {
         if (error) {
             NSLog(@"************Share fail with error %@*********",error);
         }
         else {
             NSLog(@"response data is %@",result);
             [ZZHUD showTaskInfoWithStatus:@"分享成功"];
         }
        
        [self close];
    }];
}


#pragma mark Layout
- (void)layout {
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [_contentView addSubview:self.titleImageView];
    [_contentView addSubview:self.titleLeftImageView];
    [_contentView addSubview:self.titleRightImageView];
    [_contentView addSubview:self.closeBtn];
    [_contentView addSubview:self.subTitleLabel];
    [_contentView addSubview:self.descLabel];
    [_contentView addSubview:self.bottomTitleLabel];
    
    UIView *linkView = [self createShareButtonView:CommissionChannelLink];
    [_contentView addSubview:linkView];
    
    UIView *momentsView = [self createShareButtonView:CommissionChannelMoments];
    [_contentView addSubview:momentsView];
    
    UIView *weChatView = [self createShareButtonView:CommissionChannelWechat];
    [_contentView addSubview:weChatView];
    
    _bgView.frame = self.bounds;
    
    _contentView.frame = CGRectMake(self.width * 0.5 - 300 * 0.5, self.height, 292, 329);

    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(_contentView);
        make.height.equalTo(@56);
    }];
    
    [_titleLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(-16.0);
        make.top.equalTo(_contentView).offset(-4.5);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    
    [_titleRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_contentView).offset(10.0);
        make.top.equalTo(_contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_contentView).offset(-10.0);
        make.top.equalTo(_contentView).offset(15.0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentView);
        make.top.equalTo(_titleImageView.mas_bottom).offset(28);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentView);
        make.top.equalTo(_subTitleLabel.mas_bottom).offset(12);
        make.left.equalTo(_contentView).offset(27.0);
        make.right.equalTo(_contentView).offset(-27.0);
    }];
    
    
    CGFloat viewWidth = 44.0;
    [linkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(viewWidth, 60.0));
        make.top.equalTo(_descLabel.mas_bottom).offset(32.0);
        make.left.equalTo(_contentView).offset(viewWidth * 0 + 50.0);
    }];
    
    [momentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(viewWidth, 60.0));
        make.top.equalTo(_descLabel.mas_bottom).offset(32.0);
        make.left.equalTo(linkView.mas_right).offset(30.0);
    }];
    
    [weChatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(viewWidth, 60.0));
        make.top.equalTo(_descLabel.mas_bottom).offset(32.0);
        make.left.equalTo(momentsView.mas_right).offset(30.0);
    }];
    
    [_bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(_contentView);
        make.height.equalTo(@31);
    }];
}

- (UIView *)createShareButtonView:(CommissionChannel)channel {
    UIView *view = [[UIView alloc] init];
    view.tag = channel;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = RGBCOLOR(153, 163, 163);
    [view addSubview:titleLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(imageView.mas_bottom).offset(1);
        make.left.equalTo(view);
        make.right.equalTo(view);
    }];
    
    NSString *imageIcon = nil;
    NSString *title = nil;
    switch (channel) {
        case CommissionChannelMoments: {
            imageIcon = @"CommissionChannelMoments";
            title =  @"朋友圈";
            break;
        }
        case CommissionChannelWechat: {
            imageIcon = @"CommissionChannelWeChat";
            title = @"微信";
            break;
        }
        case CommissionChannelLink: {
            imageIcon = @"icLjfx";
            title = @"链接分享";
            break;
        }
        default:
            break;
    }
    
    imageView.image = [UIImage imageNamed:imageIcon];
    titleLabel.text = title;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(share:)];
    [view addGestureRecognizer:tap];
    
    return view;
}


#pragma mark getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.0;
    }
    return _bgView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColor.whiteColor;
        _contentView.layer.cornerRadius = 6.0;
    }
    return _contentView;
}

- (UIImageView *)titleImageView {
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.image = [UIImage imageNamed:@"picSqchg"];
    }
    return _titleImageView;
}

- (UIImageView *)titleLeftImageView {
    if (!_titleLeftImageView) {
        _titleLeftImageView = [[UIImageView alloc] init];
        _titleLeftImageView.image = [UIImage imageNamed:@"icJinbi_big"];
    }
    return _titleLeftImageView;
}

- (UIImageView *)titleRightImageView {
    if (!_titleRightImageView) {
        _titleRightImageView = [[UIImageView alloc] init];
        _titleRightImageView.image = [UIImage imageNamed:@"icJinbi"];
    }
    return _titleRightImageView;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.text = @"请等待审核，预计1-2日到账";
        _subTitleLabel.textColor = RGBCOLOR(102, 102, 102);
    }
    return _subTitleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.text = @"邀请好友注册，他消费、收入你都躺赚分红，分享至朋友圈，80%的用户成功邀请3-10人";
        _descLabel.textColor = RGBCOLOR(63, 58, 58);
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (UILabel *)bottomTitleLabel {
    if (!_bottomTitleLabel) {
        _bottomTitleLabel = [[UILabel alloc] init];
        _bottomTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        _bottomTitleLabel.textAlignment = NSTextAlignmentCenter;
        _bottomTitleLabel.text = @"分享至5人以上微信群，邀请成功率达99%";
        _bottomTitleLabel.textColor = RGBCOLOR(102, 102, 102);
        _bottomTitleLabel.numberOfLines = 0;
        _bottomTitleLabel.backgroundColor = RGBCOLOR(216, 216, 216);
    }
    return _bottomTitleLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"icClose_white"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (ZZCommissionShareToastDoubleCheckView *)doubleCheckView {
    if (!_doubleCheckView) {
        _doubleCheckView = [[ZZCommissionShareToastDoubleCheckView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 292 / 2, SCREEN_HEIGHT, 292, 310)];
        [_doubleCheckView.closeBtn addTarget:self action:@selector(doubleCheckCloseAction) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(share:)];
        [_doubleCheckView.linkView addGestureRecognizer:tap];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(share:)];
        [_doubleCheckView.momentView addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(share:)];
        [_doubleCheckView.weChatView addGestureRecognizer:tap2];
        
        [self addSubview:_doubleCheckView];
    }
    return _doubleCheckView;
}

@end


#pragma mark - ZZCommissionShareToastDoubleCheckView
@interface ZZCommissionShareToastDoubleCheckView ()

@end

@implementation ZZCommissionShareToastDoubleCheckView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}


#pragma mark Layout
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 6.0;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImageView];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.closeBtn];
    
    _linkView = [self createShareButtonView:CommissionChannelLink];
    [self addSubview:_linkView];
    
    _momentView = [self createShareButtonView:CommissionChannelMoments];
    [self addSubview:_momentView];
    
    _weChatView = [self createShareButtonView:CommissionChannelWechat];
    [self addSubview:_weChatView];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(21);
        make.left.equalTo(self).offset(42);
        make.right.equalTo(self).offset(-42);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10.0);
        make.top.equalTo(self).offset(15.0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_titleLabel.mas_bottom).offset(16);
        make.size.mas_equalTo(CGSizeMake(75, 49));
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_iconImageView.mas_bottom).offset(25);
        make.left.equalTo(self).offset(27.0);
        make.right.equalTo(self).offset(-27.0);
    }];
    
    CGFloat viewWidth = 44.0;
    [_linkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(viewWidth, 60.0));
        make.top.equalTo(_subTitleLabel.mas_bottom).offset(32.0);
        make.left.equalTo(self).offset(viewWidth * 0 + 50.0);
    }];
    
    [_momentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(viewWidth, 60.0));
        make.top.equalTo(_subTitleLabel.mas_bottom).offset(32.0);
        make.left.equalTo(_linkView.mas_right).offset(30.0);
    }];
    
    [_weChatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(viewWidth, 60.0));
        make.top.equalTo(_subTitleLabel.mas_bottom).offset(32.0);
        make.left.equalTo(_momentView.mas_right).offset(30.0);
    }];
}

- (UIView *)createShareButtonView:(CommissionChannel)channel {
    UIView *view = [[UIView alloc] init];
    view.tag = channel;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = RGBCOLOR(153, 163, 163);
    [view addSubview:titleLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(imageView.mas_bottom).offset(1);
        make.left.equalTo(view);
        make.right.equalTo(view);
    }];
    
    NSString *imageIcon = nil;
    NSString *title = nil;
    switch (channel) {
        case CommissionChannelMoments: {
            imageIcon = @"CommissionChannelMoments";
            title =  @"朋友圈";
            break;
        }
        case CommissionChannelWechat: {
            imageIcon = @"CommissionChannelWeChat";
            title = @"微信";
            break;
        }
        case CommissionChannelLink: {
            imageIcon = @"icLjfx";
            title = @"链接分享";
            break;
        }
        default:
            break;
    }
    
    imageView.image = [UIImage imageNamed:imageIcon];
    titleLabel.text = title;

    return view;
}

#pragma mark getters and setters
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.text = @"分享到朋友圈，80%的用户成功邀请3-10人，分享至5人以上微信群，邀请成功率达99%";
        _subTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _subTitleLabel.numberOfLines = 0;
    }
    return _subTitleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"picWxtsTc"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"确定要放弃吗？";
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _titleLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"icGbTc"] forState:UIControlStateNormal];
        
    }
    return _closeBtn;
}

@end
