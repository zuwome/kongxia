//
//  ZZCommissionShareView.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/9.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCommissionShareView.h"
#import <UMSocialCore/UMSocialCore.h>

#import "ZZCommissionModel.h"

@interface ZZCommissionShareView() <ZZCommissionShareChannelViewDelegate>

@property (nonatomic, strong) ZZUser *user;

@property (nonatomic, assign) CommissionChannelEntry entry;

@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, strong) ZZCommissionShareChannelView *channelView;

@property (nonatomic, strong) ZZCommissionQRCodeView *qrCodeView;

@property (nonatomic, strong) UIButton *saveToAlbumBtn;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation ZZCommissionShareView

- (instancetype)initWithInfoModel:(ZZCommissionModel *)model frame:(CGRect)frame entry:(CommissionChannelEntry)entry {
    self = [super initWithFrame:frame];
    if (self) {
        _entry = entry;
        _commissionModel = model;
        [self layout];
    }
    return self;
}

- (instancetype)initWithInfoModel:(ZZCommissionModel *)model user:(ZZUser *)user frame:(CGRect)frame entry:(CommissionChannelEntry)entry {
    self = [super initWithFrame:frame];
    if (self) {
        _entry = entry;
        _commissionModel = model;
        _user = user;
        [self layout];
    }
    return self;
}

#pragma mark - Class Method
/*
 * 从某视图 获取其图像
 */
- (UIImage *)cutFromView:(UIView *)view {
    self.closeBtn.hidden = YES;
    self.saveToAlbumBtn.hidden = YES;
    self.shareBtn.hidden = YES;
    
    //开启 图形上下文
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0.0f);
    
    //获取 上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return nil;
    }

    //在新建的图形上下文中，渲染view的layer
    [view.layer renderInContext:context];

    //设定颜色：透明
    [[UIColor clearColor] setFill];

    //获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    self.closeBtn.hidden = NO;
    self.saveToAlbumBtn.hidden = NO;
    self.shareBtn.hidden = NO;
    
    return image;
}

#pragma mark - public Method
- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        if (_channelView) {
            _channelView.top = SCREEN_HEIGHT;
        }
    } completion:^(BOOL finished) {
        if (_channelView) {
            [_channelView removeFromSuperview];
            _channelView = nil;
        }
        else {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - private method
/**
 *  分享
 */
- (void)share:(CommissionChannel)channel {
    
    if (channel == CommissionChannelSnapShot) {
        UIImage *snapShot = [self cutFromView:self];
        [self saveImageToPhotoAlbum:snapShot];
        return;
    }
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    if (channel == CommissionChannelLink) {
        // 分享链接
        NSMutableString *shareContent = [_commissionModel.tip.url_text[@"conent"] mutableCopy];
        NSRange range = [shareContent rangeOfString:@"空虾用户名"];
        if (range.location != NSNotFound) {
            [shareContent replaceCharactersInRange:range withString:[ZZUserHelper shareInstance].loginer.nickname];
        }
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_commissionModel.tip.url_text[@"title"] descr:shareContent.copy thumImage:[UIImage imageNamed:@"kongxialogo"]];
        shareObject.webpageUrl = _commissionModel.inviteURL;
        messageObject.shareObject = shareObject;
    }
    else {
        // 分享图片
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        shareObject.thumbImage = [UIImage imageNamed:@"kongxialogo"];
        if (_channelView) {
            _channelView.top = SCREEN_HEIGHT;
        }
        [shareObject setShareImage:[self cutFromView:self]];
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
         }
    }];
}

/**
 *  保存图片到本地
 */
- (void)saveImageToPhotoAlbum:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存照片失败");
    }
    else {
        [ZZHUD showSuccessWithStatus:@"保存成功"];
    }
}

#pragma mark - response method
- (void)hideAction {
    [self hide];
}

/**
 *  保存在相册
 */
- (void)saveToAlbum {
    [self share:CommissionChannelSnapShot];
}

- (void)share {
    [self showChannelView];
}

- (void)close {
    [self hide];
}

#pragma mark - ZZCommissionShareChannelViewDelegate
- (void)view:(ZZCommissionShareChannelView *)view didChooseChannel:(CommissionChannel)channel {
    [self share:channel];
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.bgView];
    [self addSubview:self.saveToAlbumBtn];
    [self addSubview:self.shareBtn];
    [self addSubview:self.qrCodeView];
    
    [self addSubview:self.closeBtn];
    
    _bgView.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    CGFloat offsetX = (SCREEN_WIDTH - 144 * 2 - 13) / 2;
    _saveToAlbumBtn.frame = CGRectMake(offsetX , SCREEN_HEIGHT - 50.0 - SafeAreaBottomHeight - 25, 144.0, 50.0);
    
    _shareBtn.frame = CGRectMake(_saveToAlbumBtn.right + 13 , SCREEN_HEIGHT - 50.0 - SafeAreaBottomHeight - 25 - 5, 165.0, 72.0);
    
    if (_entry == CommissionChannelEntryMyCommission) {
        _qrCodeView.frame = CGRectMake(SCREEN_WIDTH * 0.5 - SCALE_SET(345) * 0.5, SCALE_SET(30) + STATUSBAR_HEIGHT, SCALE_SET(345), SCALE_SET(556));
    }
    else {
        _qrCodeView.frame = CGRectMake(SCREEN_WIDTH * 0.5 - SCALE_SET(345) * 0.5, SCALE_SET(30) + STATUSBAR_HEIGHT, SCALE_SET(345), SCALE_SET(609));
    }
    
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(30);
        }
        else {
            make.top.equalTo(self).offset(SCALE_SET(30));
        }
        make.size.mas_equalTo(CGSizeMake(30.0, 30.0));
    }];
}

- (void)showChannelView {
    [self addSubview:self.channelView];
    [UIView animateWithDuration:0.3 animations:^{
        _channelView.top = SCREEN_HEIGHT - _channelView.height;
    }];
}

#pragma mark - getters and setters
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.image = [UIImage imageNamed:@"CommessionPicBg"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (UIButton *)saveToAlbumBtn {
    if (!_saveToAlbumBtn) {
        _saveToAlbumBtn = [[UIButton alloc] init];
        _saveToAlbumBtn.normalTitle = @"保存到相册";
        _saveToAlbumBtn.normalTitleColor = UIColor.blackColor;
        _saveToAlbumBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
        [_saveToAlbumBtn addTarget:self action:@selector(saveToAlbum) forControlEvents:UIControlEventTouchUpInside];
        
        _saveToAlbumBtn.layer.borderColor = UIColor.blackColor.CGColor;
        _saveToAlbumBtn.layer.borderWidth = 1.5;
        _saveToAlbumBtn.layer.cornerRadius = 25;
    }
    return _saveToAlbumBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc] init];
        _shareBtn.normalImage = [UIImage imageNamed:@"icFenxiang"];
        [_shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        _closeBtn.normalImage = [UIImage imageNamed:@"back"];
        [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (ZZCommissionShareChannelView *)channelView {
    if (!_channelView) {
        _channelView = [[ZZCommissionShareChannelView alloc] initWithFrame:CGRectMake(0.0, SCREEN_HEIGHT, SCREEN_WIDTH, 162.5)];
        _channelView.delegate = self;
        [_channelView.cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_channelView];
    }
    return _channelView;
}

- (ZZCommissionQRCodeView *)qrCodeView {
    if (!_qrCodeView) {
        _qrCodeView = [[ZZCommissionQRCodeView alloc] initWithCommissionModel:_commissionModel
                                                                         user:_user ? _user : [ZZUserHelper shareInstance].loginer entry:_entry];
        _qrCodeView.frame = [UIApplication sharedApplication].keyWindow.bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_qrCodeView addGestureRecognizer:tap];
    }
    return _qrCodeView;
}

@end


@interface ZZCommissionQRCodeView ()

@property (nonatomic, assign) CommissionChannelEntry entry;

@property (nonatomic, strong) UIView *bgImageView;

@property (nonatomic, strong) UIImageView *userIconImageView;

@property (nonatomic, strong) UIImageView *bannerImageView;

@property (nonatomic, strong) UIImageView *qrcodeImageView;

@property (nonatomic, strong) UILabel *qrcodeLabel;

@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UILabel *memeLabel;

@property (nonatomic, strong) UILabel *rentLabel;

@property (nonatomic, strong) UILabel *myNameLabel;

@property (nonatomic, strong) UILabel *introTitleLabel;

@property (nonatomic, strong) UILabel *intro1Label;

@property (nonatomic, strong) UILabel *intro2Label;

@end

@implementation ZZCommissionQRCodeView

- (instancetype)initWithCommissionModel:(ZZCommissionModel *)model user:(ZZUser *)user entry:(CommissionChannelEntry)entry {
    self = [super init];
    if (self) {
        _entry = entry;
        [self layout];
        [self configureData:model user:user];
    }
    return self;
}

- (instancetype)initWithCommissionModel:(ZZCommissionModel *)model user:(ZZUser *)user frame:(CGRect)frame {
    self = [super initWithFrame:frame];
        if (self) {
            [self layout];
            self.backgroundColor = UIColor.clearColor;
            [self configureData:model user:user];
        }
        return self;
}

/*
 * 从某视图 获取其图像
 */
- (UIImage *)cutFromView {
    //开启 图形上下文
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0.0f);
    
    //获取 上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return nil;
    }

    //在新建的图形上下文中，渲染view的layer
    [self.layer renderInContext:context];

    //设定颜色：透明
    [[UIColor clearColor] setFill];

    //获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    //关闭图形上下文
    UIGraphicsEndImageContext();

    return image;
}


- (void)createQRCodeWithModel:(ZZCommissionModel *)model {
    UIImage *image = [ZZUtils createQRCodeImgWithString:model.inviteURL imgHeight:100];
    if (image) {
        _qrcodeImageView.image = [self addSubImage:image sub:[UIImage imageNamed:@"kongxialogo"]];
    }
}

- (UIImage *)addSubImage:(UIImage *)img sub:(UIImage *) subImage {
    int w = img.size.width;
    int h = img.size.height;
    int subWidth = 20 * SCALE_SIZE;
    int subHeight = 20 * SCALE_SIZE;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextDrawImage(context, CGRectMake( (w-subWidth)/2, (h - subHeight)/2, subWidth, subHeight), [subImage CGImage]);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}

- (void)configureData:(ZZCommissionModel *)model user:(ZZUser *)user {
    [self createQRCodeWithModel:model];
    
    [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:[user displayAvatar]] completed:nil];
    
    _userNameLabel.text = user.nickname;
    
    _memeLabel.text = [NSString stringWithFormat:@"么么号: %@", user.ZWMId];
    
    if (_entry == CommissionChannelEntryMyCommission) {
        // 技能
        _rentLabel.font = [UIFont boldSystemFontOfSize:12];
        _rentLabel.textColor = RGBCOLOR(102, 102, 102);
        
        NSMutableString *mutableStr = @"".mutableCopy;
        
        for (ZZTopic *topic in user.rent.topics) {
            if (topic.skills.count == 0) {  //主题无技能，跳过
                continue;
            }
            for (ZZSkill *skill in topic.skills) {
                [mutableStr appendFormat:@"#%@ ", skill.name];
            }
        }
        
        _rentLabel.text = mutableStr.copy;
    }
    else {
        // 技能名称、价格、介绍
        _rentLabel.textColor = RGBCOLOR(102, 102, 102);
        _rentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        
        ZZSkill *mostCheapSkill = nil;
        for (ZZTopic *topic in user.rent.topics) {
            if (topic.skills.count == 0) {  //主题无技能，跳过
                continue;
            }
            for (ZZSkill *skill in topic.skills) {
                if (!mostCheapSkill) {
                    mostCheapSkill = skill;
                }
                else if ([skill.price doubleValue] < [mostCheapSkill.price doubleValue]) {
                    mostCheapSkill = skill;
                }
            }
        }
        
        if (!mostCheapSkill) {
            _rentLabel.text = @"";
        }
        else {
            _rentLabel.text = [NSString stringWithFormat:@"%@: %@元/小时", mostCheapSkill.name, mostCheapSkill.price];
        }
    }
        
    _introTitleLabel.text = model.tip.user[@"title_b"];
    
    _myNameLabel.text = [ZZUserHelper shareInstance].loginer.nickname;
    
    NSArray *tipbArr = model.tip.user[@"tip_b"];
    [tipbArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            _intro1Label.text = obj;
        }
        else if (idx == 0) {
            _intro2Label.text = obj;
        }
    }];
}

#pragma mark - Layout
- (void)layout {
    
    [self addSubview:self.bgImageView];
    [_bgImageView addSubview:self.userIconImageView];
    [self addSubview:self.bannerImageView];
    [_bgImageView addSubview:self.qrcodeImageView];
    [_bgImageView addSubview:self.qrcodeLabel];
    [_bgImageView addSubview:self.userNameLabel];
    [_bgImageView addSubview:self.memeLabel];
    [_bgImageView addSubview:self.rentLabel];
    [_bgImageView addSubview:self.introTitleLabel];
    [_bgImageView addSubview:self.intro1Label];
    [_bgImageView addSubview:self.intro2Label];

    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(@(SCALE_SET(345)));
        make.height.equalTo(_entry == CommissionChannelEntryMyCommission ? @(SCALE_SET(529)) : @(SCALE_SET(582)));
    }];
    
    [_userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgImageView);
        make.top.equalTo(_bgImageView).offset(22);
        make.size.mas_equalTo(CGSizeMake(SCALE_SET(301), SCALE_SET(301)));
    }];
    
    [_bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgImageView).offset(5.0);
        make.bottom.equalTo(_bgImageView).offset(25);
        if (_entry == CommissionChannelEntryMyCommission) {
            make.width.equalTo(@188);
            make.height.equalTo(@112);
        }
        else {
            make.width.equalTo(@178);
            make.height.equalTo(@148);
        }
    }];
    
    [_qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userIconImageView.mas_bottom).offset(16);
        make.right.equalTo(_bgImageView).offset(-22.0);
        make.size.mas_equalTo(_entry == CommissionChannelEntryMyCommission ? CGSizeMake(SCALE_SET(121), SCALE_SET(121)) : CGSizeMake(SCALE_SET(132), SCALE_SET(132)));
    }];
    
    [_qrcodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_qrcodeImageView);
        make.top.equalTo(_qrcodeImageView.mas_bottom).offset(5);
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView);
        make.top.equalTo(_userIconImageView.mas_bottom).offset(16);
        make.right.equalTo(_qrcodeImageView.mas_left).offset(-15.0);
    }];

    [_memeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView);
        make.top.equalTo(_userNameLabel.mas_bottom).offset(3);
        make.right.equalTo(_qrcodeImageView.mas_left).offset(-15.0);
    }];

    [_rentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView);
        make.top.equalTo(_memeLabel.mas_bottom).offset(3);
        make.right.equalTo(_qrcodeImageView.mas_left).offset(-15.0);
    }];

    [_intro2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView);
        make.bottom.equalTo(_bgImageView).offset(-34.0);
        make.right.equalTo(_bannerImageView.mas_left).offset(-10.0);
    }];

    [_intro1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView);
        make.bottom.equalTo(_intro2Label.mas_top).offset(-2.0);
        make.right.equalTo(_bannerImageView.mas_left).offset(-10.0);
    }];

    [_introTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView);
        make.bottom.equalTo(_intro1Label.mas_top).offset(-5.0);
        make.right.equalTo(_bannerImageView.mas_left).offset(-10.0);
    }];
    
    if (_entry == CommissionChannelEntryUser) {
        [_bgImageView addSubview:self.myNameLabel];
        
        [_myNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userIconImageView);
            make.bottom.equalTo(_introTitleLabel.mas_top);
            make.right.equalTo(_bannerImageView.mas_left).offset(-10.0);
        }];
    }
}

#pragma mark - getters and setters
- (UIView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIView alloc] init];
        _bgImageView.backgroundColor = UIColor.whiteColor;
        _bgImageView.layer.cornerRadius = 4;
    }
    return _bgImageView;
}

- (UIImageView *)qrcodeImageView {
    if (!_qrcodeImageView) {
        _qrcodeImageView = [[UIImageView alloc] init];
        _qrcodeImageView.userInteractionEnabled = NO;
        _qrcodeImageView.backgroundColor = UIColor.whiteColor;
        _qrcodeImageView.layer.borderWidth = 1;
        _qrcodeImageView.layer.borderColor = RGBCOLOR(190, 190, 190).CGColor;
    }
    return _qrcodeImageView;
}

- (UILabel *)qrcodeLabel {
    if (!_qrcodeLabel) {
        _qrcodeLabel = [[UILabel alloc] init];
        _qrcodeLabel.textColor = RGBCOLOR(102, 102, 102);
        _qrcodeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        _qrcodeLabel.text = @"长按扫码下载";
    }
    return _qrcodeLabel;
}

- (UIImageView *)bannerImageView {
    if (!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] init];
        if (_entry == CommissionChannelEntryMyCommission) {
            _bannerImageView.image = [UIImage imageNamed:@"icBiaoyu"];
        }
        else {
            _bannerImageView.image = [UIImage imageNamed:@"icBiaoyu1"];
        }
    }
    return _bannerImageView;
}

- (UIImageView *)userIconImageView {
    if (!_userIconImageView) {
        _userIconImageView = [[UIImageView alloc] init];
    }
    return _userIconImageView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.textColor = RGBCOLOR(51, 51, 51);
        _userNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    }
    return _userNameLabel;
}

- (UILabel *)memeLabel {
    if (!_memeLabel) {
        _memeLabel = [[UILabel alloc] init];
        _memeLabel.textColor = RGBCOLOR(102, 102, 102);
        _memeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    }
    return _memeLabel;
}

- (UILabel *)rentLabel {
    if (!_rentLabel) {
        _rentLabel = [[UILabel alloc] init];
        _rentLabel.textColor = RGBCOLOR(102, 102, 102);
        _rentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        _rentLabel.numberOfLines = 0;
    }
    return _rentLabel;
}

- (UILabel *)myNameLabel {
    if (!_myNameLabel) {
        _myNameLabel = [[UILabel alloc] init];
        _myNameLabel.textColor = RGBCOLOR(63, 58, 58);
        _myNameLabel.font = [UIFont fontWithName:@"Alibaba-PuHuiTi-M" size:16];
        _myNameLabel.text = @"邀请您加入空虾";
    }
    return _myNameLabel;
}

- (UILabel *)introTitleLabel {
    if (!_introTitleLabel) {
        _introTitleLabel = [[UILabel alloc] init];
        _introTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _introTitleLabel.font = [UIFont fontWithName:@"Alibaba-PuHuiTi-B" size:18];
        _introTitleLabel.text = @"邀请您加入空虾";
    }
    return _introTitleLabel;
}

- (UILabel *)intro1Label {
    if (!_intro1Label) {
        _intro1Label = [[UILabel alloc] init];
        _intro1Label.textColor = RGBCOLOR(63, 58, 58);
        _intro1Label.font = [UIFont fontWithName:@"Alibaba-PuHuiTi-R" size:12];
        _intro1Label.text = @"轻松月入2万";
    }
    return _intro1Label;
}

- (UILabel *)intro2Label {
    if (!_intro2Label) {
        _intro2Label = [[UILabel alloc] init];
        _intro2Label.textColor = RGBCOLOR(63, 58, 58);
        _intro2Label.font = [UIFont fontWithName:@"Alibaba-PuHuiTi-R" size:12];
        _intro2Label.text = @"结识百万优质新朋友";
    }
    return _intro2Label;
}

@end


@interface ZZCommissionShareChannelView ()

@end

@implementation ZZCommissionShareChannelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - response method
- (void)chooseChannel:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:didChooseChannel:)]) {
        [self.delegate view:self didChooseChannel:sender.tag];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(247, 247, 247);
    [self addSubview:self.cancelBtn];
    
    _cancelBtn.frame = CGRectMake(0.0, self.height - 44, SCREEN_WIDTH, 44);
    
    NSInteger count = 3;
    CGFloat btnWidth = 80.0; //93
    CGFloat offset = (self.width - btnWidth * count) / (count + 1);
    for (int i = 0; i < count; i++) {
        CommissionChannel channel = CommissionChannelMoments;
        if (i == 0) {
            channel = CommissionChannelMoments;
        }
        else if (i == 1) {
            channel = CommissionChannelWechat;
        }
        else if (i == 2) {
            channel = CommissionChannelLink;
        }
        UIButton *btn = [self createBtn:channel];
        btn.frame = CGRectMake(offset + (btnWidth + offset) * i, 25, btnWidth, 70.0);
        [self addSubview:btn];
        [btn setImagePosition:LXMImagePositionTop spacing:2];
    }
}

- (UIButton *)createBtn:(CommissionChannel)channel {
    UIButton *btn = [[UIButton alloc] init];
    switch (channel) {
        case CommissionChannelMoments: {
            btn.normalImage = [UIImage imageNamed:@"CommissionChannelMoments"];
            btn.normalTitle = @"朋友圈";
            break;
        }
        case CommissionChannelWechat: {
            btn.normalImage = [UIImage imageNamed:@"CommissionChannelWeChat"];
            btn.normalTitle = @"微信";
            break;
        }
        case CommissionChannelLink: {
            btn.normalImage = [UIImage imageNamed:@"icLjfx"];
            btn.normalTitle = @"链接分享";
            break;
        }
        default:
            break;
    }
    btn.normalTitleColor = RGBCOLOR(63, 58, 58);
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    btn.tag = channel;
    
    [btn addTarget:self action:@selector(chooseChannel:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - getters and setters
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.normalTitle = @"取消";
        _cancelBtn.normalTitleColor = RGBCOLOR(102, 102, 102);
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _cancelBtn.backgroundColor = UIColor.whiteColor;
    }
    return _cancelBtn;
}

@end
