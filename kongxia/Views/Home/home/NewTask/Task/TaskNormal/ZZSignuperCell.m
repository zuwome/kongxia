//
//  ZZSignuperCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/21.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZSignuperCell.h"
#import "ZZTaskSignuperModel.h"
#import "ZZDateHelper.h"

@interface ZZSignuperCell ()

@property (nonatomic, strong) UIView *signUperView;

@property (nonatomic, strong) UIImageView *userIconImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *genderImageView;

@property (nonatomic, strong) UIImageView *verifyImageView;

@property (nonatomic, strong) ZZLevelImgView *levelImageView;

@property (nonatomic, strong) UIButton *chatBtn;

@property (nonatomic, strong) UIImageView *sinaVerifyImageView;

@property (nonatomic, strong) UILabel *introduceLabel;

@property (nonatomic, strong) UIImageView *distanceImageView;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) UILabel *signUpDateLabel;

@property (nonatomic, strong) UIButton *pickBtn;

@property (nonatomic, strong) UILabel *pickLabel;

@end

@implementation ZZSignuperCell

+ (NSString *)cellIdentifier {
    return @"ZZSignuperCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)didPicked:(BOOL)didPicked {
    [_pickBtn setSelected:didPicked];
}

- (void)configureViews {
    if (_item.isNewTask) {
        _nameLabel.font = CustomFont(11.0);
        _nameLabel.textColor = UIColor.whiteColor;
        
        [_pickBtn setTitle:@"选TA" forState:UIControlStateNormal];
        _pickBtn.normalImage = [UIImage imageNamed:@"icXuanrenWeixuanze"];
        _pickBtn.selectedImage = [UIImage imageNamed:@"icXuanren"];
        
        [_chatBtn setTitleColor:RGBCOLOR(63, 58, 58) forState:UIControlStateNormal];
        _chatBtn.titleLabel.font = CustomFont(13.0);
        _chatBtn.backgroundColor = kGoldenRod;
    }
    else {
        _nameLabel.font = CustomFont(14.0);
        _nameLabel.textColor = RGBCOLOR(63, 58, 58);

        [_chatBtn setTitleColor:RGBCOLOR(244, 203, 7) forState:UIControlStateNormal];
        [_chatBtn setImage:[UIImage imageNamed:@"icSixinYaoyue"] forState:UIControlStateNormal];
        _chatBtn.titleLabel.font = CustomFont(12.0);
        
        [_pickBtn setTitle:@"选TA" forState:UIControlStateNormal];
        [_pickBtn setTitleColor:RGBCOLOR(63, 58, 58) forState:UIControlStateNormal];
        _pickBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        _pickBtn.backgroundColor = kGoldenRod;
        _pickBtn.layer.cornerRadius = 2.0;
    }
}

- (void)configureData {
    if ([_item isKindOfClass: [TaskSignuperItem class]]) {
        TaskSignuperItem *item = (TaskSignuperItem *)_item;
        
        // iCon
        [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:[item.signUper.user displayAvatar]]];
        
        // name
        _nameLabel.text = item.signUper.user.nickname;
        
        // gender
        if (item.signUper.user.gender == 2) {
            _genderImageView.image = [UIImage imageNamed:@"girl"];
        }
        else if (item.signUper.user.gender == 1) {
            _genderImageView.image = [UIImage imageNamed:@"boy"];
        }
        else {
            _genderImageView.image = [UIImage imageNamed:@""];
        }
        
        // verify
        if ([item.signUper.user isIdentifierCertified]) {
            [_verifyImageView setHidden: NO];
        }
        else {
            [_verifyImageView setHidden: YES];
        }
        
        // level
        [_levelImageView setLevel:item.signUper.user.level];
        
        // weibo
        if (item.signUper.user.weibo.verified) {
            _sinaVerifyImageView.hidden = NO;
            [_introduceLabel setHidden:NO];
            _introduceLabel.text = item.signUper.user.weibo.verified_reason;
        }
        else {
            _sinaVerifyImageView.hidden = YES;
            [_introduceLabel setHidden:YES];
        }
        
        // distance
        _distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", item.signUper.pd_km.doubleValue];
        
        // 时间
        _signUpDateLabel.text = [NSString stringWithFormat:@"%@ 已报名",[ZZDateHelper localTime:item.signUper.selected_at dateType:@"MM-dd HH:mm:ss"]];
        
        [self layoutFrames];
    }
}

- (void)goChat {
    if ([_item isKindOfClass: [TaskSignuperItem class]]) {
        TaskSignuperItem *item = (TaskSignuperItem *)_item;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:goChat:)]) {
            [self.delegate cell:self goChat:item.signUper.user];
        }
    }
}

- (void)pick {
    if ([_item isKindOfClass: [TaskSignuperItem class]]) {
        TaskSignuperItem *item = (TaskSignuperItem *)_item;

        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:pickUser:)]) {
            [self.delegate cell:self pickUser:item];
        }
    }
}

- (void)layout {
    self.backgroundColor = RGBCOLOR(247, 247, 247);
    [self.contentView addSubview:self.signUperView];
    [_signUperView addSubview:self.userIconImageView];
    [_signUperView addSubview:self.nameLabel];
    [_signUperView addSubview:self.genderImageView];
    [_signUperView addSubview:self.verifyImageView];
    [_signUperView addSubview:self.levelImageView];
    [_signUperView addSubview:self.chatBtn];
    
    [_signUperView addSubview:self.sinaVerifyImageView];
    [_signUperView addSubview:self.introduceLabel];
    [_signUperView addSubview:self.distanceImageView];
    [_signUperView addSubview:self.distanceLabel];
    [_signUperView addSubview:self.signUpDateLabel];
    [_signUperView addSubview:self.pickBtn];
    [_signUperView addSubview:self.pickLabel];
}

- (void)layoutFrames {
    if (_item.isNewTask) {
        [self layoutNewFrames];
    }
    else {
        [self layoutOldFrames];
    }
}

- (void)layoutNewFrames {
    _pickLabel.hidden = NO;
    _signUperView.frame = CGRectMake(7.0, 0.0, self.width - 14.0, 124.0);
    _userIconImageView.frame = CGRectMake(0.0, 0.0, 124.0, 124.0);
    
    CGFloat distanceLWidth = [NSString findWidthForText:_item.signUper.user.nickname havingWidth:60 andFont:_nameLabel.font];
    _nameLabel.frame = CGRectMake(_userIconImageView.left + 10.0, 106.0, distanceLWidth, _nameLabel.font.lineHeight);
    
    if (_item.signUper.user.gender == 2 || _item.signUper.user.gender == 1) {
        _genderImageView.frame = CGRectMake(_nameLabel.right + 5.0,
                                            _nameLabel.height * 0.5 - 6 + _nameLabel.top,
                                            12,
                                            12);
    }
    else {
        _genderImageView.frame = CGRectMake(_nameLabel.right,
                                            _nameLabel.height * 0.5 - 6 + _nameLabel.top,
                                            0.0,
                                            0.0);
    }
    
    //    if ([_item.signUper.user isIdentifierCertified]) {
    //        [_verifyImageView setHidden: NO];
    //        _verifyImageView.frame = CGRectMake(_genderImageView.right + 7,
    //                                            _nameLabel.height * 0.5 - 7 + _nameLabel.top,
    //                                            19,
    //                                            14);
    //    }
    //    else {
    [_verifyImageView setHidden: YES];
    _verifyImageView.frame = CGRectMake(_genderImageView.right,
                                        _nameLabel.height * 0.5 - 7 + _nameLabel.top,
                                        0.0,
                                        0.0);
    //    }
    
    _levelImageView.frame = CGRectMake(_verifyImageView.right + 7,
                                       _nameLabel.height * 0.5 - 7 + _nameLabel.top,
                                       28.0,
                                       14.0);
    
    // 私信
    _chatBtn.frame = CGRectMake(_signUperView.width - 50.0 - 15.0 , 10.0, 46.0, 23.0);
    
    // 报名时间
    CGFloat maxWidth = _chatBtn.left - _userIconImageView.right - 28.0;
    CGFloat signUpWidth = [NSString findWidthForText:_signUpDateLabel.text havingWidth:maxWidth andFont:_signUpDateLabel.font];
    _signUpDateLabel.frame = CGRectMake(_userIconImageView.right + 10.0, 10, signUpWidth, _signUpDateLabel.font.lineHeight);
    
    // 新浪的认证
    _sinaVerifyImageView.frame = CGRectMake(_signUpDateLabel.left, _signUpDateLabel.bottom + 7.5, 12, 12);
    _introduceLabel.frame = CGRectMake(_sinaVerifyImageView.right + 3.5,
                                       _sinaVerifyImageView.height * 0.5 - _introduceLabel.font.lineHeight * 0.5 + _sinaVerifyImageView.top,
                                       _signUperView.width - _sinaVerifyImageView.right - 20,
                                       _introduceLabel.font.lineHeight);
    
    // 选它Label
    _pickLabel.frame = CGRectMake(_signUperView.width - 10 - 46.0, _signUperView.height - 7 - 23, 30, 18.5);
    
    // 选它 btn
    _pickBtn.frame = CGRectMake(_signUperView.width - 10 - 36.0, _pickLabel.top - 36, 36, 36);
    
    // 距离 icon
    _distanceImageView.frame = CGRectMake(_signUpDateLabel.left, _signUperView.height - 12.0 - 11.0, 9.0, 11.0);
    _distanceLabel.frame = CGRectMake(_distanceImageView.right + 3.0, _distanceImageView.height * 0.5 - _distanceLabel.font.lineHeight * 0.5 + _distanceImageView.top, 200, _distanceLabel.font.lineHeight);
}

- (void)layoutOldFrames {
    _pickLabel.hidden = YES;
    _signUperView.frame = CGRectMake(7.0, 0.0, self.width - 14.0, 124.0);
    _userIconImageView.frame = CGRectMake(0.0, 0.0, 124.0, 124.0);
    
    CGFloat distanceLWidth = [NSString findWidthForText:_item.signUper.user.nickname havingWidth:90 andFont:_nameLabel.font];
    _nameLabel.frame = CGRectMake(_userIconImageView.right + 10.0, 10.0, distanceLWidth, _nameLabel.font.lineHeight);
    
    if (_item.signUper.user.gender == 2 || _item.signUper.user.gender == 1) {
        _genderImageView.frame = CGRectMake(_nameLabel.right + 5.0,
                                            _nameLabel.height * 0.5 - 6 + _nameLabel.top,
                                            12,
                                            12);
    }
    else {
        _genderImageView.frame = CGRectMake(_nameLabel.right,
                                            _nameLabel.height * 0.5 - 6 + _nameLabel.top,
                                            0.0,
                                            0.0);
    }
    
    if ([_item.signUper.user isIdentifierCertified]) {
        [_verifyImageView setHidden: NO];
        _verifyImageView.frame = CGRectMake(_genderImageView.right + 7,
                                            _nameLabel.height * 0.5 - 7 + _nameLabel.top,
                                            19,
                                            14);
    }
    else {
        [_verifyImageView setHidden: YES];
        _verifyImageView.frame = CGRectMake(_genderImageView.right,
                                            _nameLabel.height * 0.5 - 7 + _nameLabel.top,
                                            0.0,
                                            0.0);
    }
    
    _levelImageView.frame = CGRectMake(_verifyImageView.right + 7,
                                       _nameLabel.height * 0.5 - 7 + _nameLabel.top,
                                       28.0,
                                       14.0);
    
    _chatBtn.frame = CGRectMake(_signUperView.width - 50.0 - 15.0 , _nameLabel.height * 0.5 - 7.4 + _nameLabel.top, 50.0, 15.0);
    if (_item.isNewTask) {
        [_chatBtn setImagePosition:LXMImagePositionLeft spacing:0];
    }
    else {
        [_chatBtn setImagePosition:LXMImagePositionLeft spacing:4];
    }
    
    _sinaVerifyImageView.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + 7.5, 12, 12);
    _introduceLabel.frame = CGRectMake(_sinaVerifyImageView.right + 3.5,
                                       _sinaVerifyImageView.height * 0.5 - _introduceLabel.font.lineHeight * 0.5 + _sinaVerifyImageView.top,
                                       _signUperView.width - _sinaVerifyImageView.right - 20,
                                       _introduceLabel.font.lineHeight);
    
    _pickBtn.frame = CGRectMake(_signUperView.width - 10 - 46.0, _signUperView.height - 7 - 23, 46, 23);
    
    CGFloat maxWidth = _pickBtn.left - _userIconImageView.right - 28.0;
    CGFloat signUpWidth = [NSString findWidthForText:_signUpDateLabel.text havingWidth:maxWidth andFont:_signUpDateLabel.font];
    _signUpDateLabel.frame = CGRectMake(_nameLabel.left, _signUperView.height - 9 - _signUpDateLabel.font.lineHeight, signUpWidth, _signUpDateLabel.font.lineHeight);
    
    _distanceImageView.frame = CGRectMake(_nameLabel.left, _signUpDateLabel.top - 8.0 - 11.0, 9.0, 11.0);
    
    _distanceLabel.frame = CGRectMake(_distanceImageView.right + 3.0, _distanceImageView.height * 0.5 - _distanceLabel.font.lineHeight * 0.5 + _distanceImageView.top, 200, _distanceLabel.font.lineHeight);
}

#pragma mark - Getter&Setter
- (void)setItem:(TaskItem *)item {
    _item = (TaskSignuperItem *)item;
    [self configureViews];
    [self configureData];
}

- (UIImageView *)userIconImageView {
    if (!_userIconImageView) {
        _userIconImageView = [[UIImageView alloc] init];
        _userIconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _userIconImageView.layer.masksToBounds = YES;
    }
    return _userIconImageView;
}

- (UIView *)signUperView {
    if (!_signUperView) {
        _signUperView = [[UIView alloc] init];
        _signUperView.layer.cornerRadius = 2;
        _signUperView.backgroundColor = UIColor.whiteColor;
    }
    return _signUperView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = CustomFont(11.0);
        _nameLabel.textColor = UIColor.whiteColor;
//        _nameLabel.text = @"挖哈哈哈哈";
    }
    return _nameLabel;
}

- (UIImageView *)genderImageView {
    if (!_genderImageView) {
        _genderImageView = [[UIImageView alloc] init];
    }
    return _genderImageView;
}

- (UIImageView *)verifyImageView {
    if (!_verifyImageView) {
        _verifyImageView = [[UIImageView alloc] init];
        _verifyImageView.image = [UIImage imageNamed:@"icon_identifier"];
    }
    return _verifyImageView;
}

- (ZZLevelImgView *)levelImageView {
    if (!_levelImageView) {
        _levelImageView = [[ZZLevelImgView alloc] init];
    }
    return _levelImageView;
}

- (UIButton *)chatBtn {
    if (!_chatBtn) {
        _chatBtn = [[UIButton alloc] init];
        [_chatBtn setTitle:@"私信" forState:UIControlStateNormal];
//        [_chatBtn setTitleColor:RGBCOLOR(63, 58, 58) forState:UIControlStateNormal];
////        [_chatBtn setImage:[UIImage imageNamed:@"icSixinYaoyue"] forState:UIControlStateNormal];
//        _chatBtn.titleLabel.font = CustomFont(13.0);
//        _chatBtn.backgroundColor = kGoldenRod;
        [_chatBtn addTarget:self action:@selector(goChat) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatBtn;
}

- (UIImageView *)sinaVerifyImageView {
    if (!_sinaVerifyImageView) {
        _sinaVerifyImageView = [[UIImageView alloc] init];
        _sinaVerifyImageView.image = [UIImage imageNamed:@"v"];
    }
    return _sinaVerifyImageView;
}

- (UILabel *)introduceLabel {
    if (!_introduceLabel) {
        _introduceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _introduceLabel.font = CustomFont(12.0);
        _introduceLabel.textColor = RGBCOLOR(122, 122, 123);
    }
    return _introduceLabel;
}

- (UIImageView *)distanceImageView {
    if (!_distanceImageView) {
        _distanceImageView = [[UIImageView alloc] init];
        _distanceImageView.image = [UIImage imageNamed:@"icQiangdanXianxiaLocationCopy2"];
    }
    return _distanceImageView;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _distanceLabel.font = CustomFont(12.0);
        _distanceLabel.textColor = RGBCOLOR(102, 102, 102);
    }
    return _distanceLabel;
}

- (UILabel *)signUpDateLabel {
    if (!_signUpDateLabel) {
        _signUpDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _signUpDateLabel.font = CustomFont(11.0);
        _signUpDateLabel.textColor = RGBCOLOR(153, 153, 153);
    }
    return _signUpDateLabel;
}

- (UIButton *)pickBtn {
    if (!_pickBtn) {
        _pickBtn = [[UIButton alloc] init];
//        _pickBtn.normalImage = [UIImage imageNamed:@"icXuanrenWeixuanze"];
//        _pickBtn.selectedImage = [UIImage imageNamed:@"icXuanren"];
        [_pickBtn addTarget:self action:@selector(pick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pickBtn;
}

- (UILabel *)pickLabel {
    if (!_pickLabel) {
        _pickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _pickLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _pickLabel.textColor = RGBCOLOR(63, 58, 58);
        _pickLabel.text = @"选TA";
        _pickLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pick)];
        [_pickLabel addGestureRecognizer:tap];
    }
    return _pickLabel;
}

@end
