//
//  ZZRentPageHeadView.m
//  zuwome
//
//  Created by angBiu on 16/8/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentPageHeadView.h"
#import "ZZRentPageHeadCollectionViewCell.h"
#import "ZZSKModel.h"
#import "AdView.h"

@interface ZZRentPageHeadView ()

@property (nonatomic, strong) UIView *frontView;
@property (nonatomic, strong) UILabel *attentLabel;
@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UILabel *realFaceTipsLabel;//没有真实头像提示
@property (nonatomic, strong) UIView *realFaceTipsView;

@property (nonatomic, strong) UIButton *playButton;//如果有达人视频，则第一个banner显示

@property (nonatomic, strong) UIImageView *blurImageView; //毛玻璃

@end

@implementation ZZRentPageHeadView
{
    ZZUser              *_user;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.collectionView.bounces = NO;
        
        UIImageView *boomImgView = [[UIImageView alloc] init];
        boomImgView.contentMode = UIViewContentModeScaleToFill;
        boomImgView.image = [UIImage imageNamed:@"icon_rent_bottombg"];
        [self addSubview:boomImgView];
        
        [boomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(@90);
        }];
        
        [self createSubviews];
    }
    
    return self;
}

- (void)createSubviews
{
    self.attentLabel.text = @"0";
    self.fansLabel.text = @"0";
    
    self.realFaceTipsView = [[UIView alloc] init];
    self.realFaceTipsView.backgroundColor = UIColor.clearColor;
    [self addSubview:self.realFaceTipsView];
    
    _realFaceTipsView.frame = CGRectMake(0.0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 44.0);
    
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEffectView.frame = _realFaceTipsView.bounds;
    visualEffectView.alpha = 0.8;
    [_realFaceTipsView addSubview:visualEffectView];

    
    self.realFaceTipsLabel = [UILabel new];
    self.realFaceTipsLabel.textColor = UIColor.whiteColor;
    self.realFaceTipsLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    self.realFaceTipsLabel.numberOfLines = 2;
    self.realFaceTipsLabel.textAlignment = NSTextAlignmentCenter;

    self.faceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icProfileBlur"]];
    [_realFaceTipsView addSubview:self.realFaceTipsLabel];
    [_realFaceTipsView addSubview:self.faceImageView];
    
    [_realFaceTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_realFaceTipsView);
        make.leading.greaterThanOrEqualTo(@35);
        make.trailing.lessThanOrEqualTo(@(-35));
    }];
    
    [self.faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.realFaceTipsLabel.mas_leading).offset(-5);
        make.top.equalTo(self.realFaceTipsLabel).offset(1);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    
    _locationImgView = [[UIImageView alloc] init];
    _locationImgView.contentMode = UIViewContentModeCenter;
    _locationImgView.image = [UIImage imageNamed:@"icon_rent_location"];
    [self addSubview:_locationImgView];
    
    [_locationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.bottom.mas_equalTo(_attentLabel.mas_top).offset(-8);
        make.size.mas_equalTo(CGSizeMake(11, 14));
    }];
    
    _locationLabel = [[UILabel alloc] init];
    _locationLabel.textAlignment = NSTextAlignmentLeft;
    _locationLabel.textColor = [UIColor whiteColor];
    _locationLabel.font = [UIFont systemFontOfSize:12];
    _locationLabel.text = @"厦门市";
    [self addSubview:_locationLabel];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_locationImgView.mas_centerY);
        make.left.mas_equalTo(_locationImgView.mas_right).offset(3);
    }];
    
    _identifierImgView = [[UIImageView alloc] init];
    _identifierImgView.image = [UIImage imageNamed:@"icon_rent_identifier"];
    _identifierImgView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_identifierImgView];
    
    [_identifierImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_locationImgView.mas_left);
        make.bottom.mas_equalTo(_locationImgView.mas_top).offset(-8);
        make.size.mas_equalTo(CGSizeMake(18, 14));
    }];
    
    _sexLabel = [[UILabel alloc] init];
    _sexLabel.textAlignment = NSTextAlignmentLeft;
    _sexLabel.textColor = [UIColor whiteColor];
    _sexLabel.font = [UIFont systemFontOfSize:12];
    _sexLabel.text = @"男";
    [self addSubview:_sexLabel];
    
    [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_locationImgView.mas_left).offset(21);
        make.centerY.mas_equalTo(_identifierImgView.mas_centerY);
    }];
    
    _ageLabel = [[UILabel alloc] init];
    _ageLabel.textAlignment = NSTextAlignmentLeft;
    _ageLabel.textColor = [UIColor whiteColor];
    _ageLabel.font = [UIFont systemFontOfSize:12];
    _ageLabel.text = @"90后";
    [self addSubview:_ageLabel];
    
    [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_sexLabel.mas_right).offset(3);
        make.centerY.mas_equalTo(_sexLabel.mas_centerY);
    }];
    
    _attentView = [[ZZAttentView alloc] init];
    _attentView.fontSize = 15;
    [self addSubview:_attentView];
    
    [_attentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-28);
        make.size.mas_equalTo(CGSizeMake(74, 32));
    }];
    
    _editBtn = [[UIButton alloc] init];
    [_editBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
    [_editBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.hidden = YES;
    _editBtn.layer.cornerRadius = 2;
    _editBtn.backgroundColor = kYellowColor;
    _editBtn.clipsToBounds = YES;
    [self addSubview:_editBtn];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_attentView);
    }];
    
    _frontView = [[UIView alloc] initWithFrame:CGRectMake(0, -15, 74, 32+40)];
    _frontView.userInteractionEnabled = NO;
    _frontView.backgroundColor = HEXCOLOR(0xffe462);
    [_editBtn addSubview:_frontView];
    
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPageIndicatorTintColor = kYellowColor;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 1;
    [self addSubview:_pageControl];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_attentView.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(@28);
    }];
    
    [self addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-29.0);
        make.height.equalTo(@29);
    }];
    
    _blurImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 75 / 2, SCREEN_WIDTH - 29 - 29 , 75, 29)];
    _blurImageView.image = [UIImage imageFromColor:RGBACOLOR(255, 255, 255, 1)];

    [_playButton addSubview:_blurImageView];
    [_blurImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_playButton);
    }];
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:beffect];
    [_blurImageView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_blurImageView);
    }];
    
    [_playButton bringSubviewToFront:_playButton.titleLabel];
    [_playButton bringSubviewToFront:_playButton.imageView];
}

- (void)createMask
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = _frontView.bounds;
    layer.colors = @[(id)[UIColor clearColor].CGColor,(id)HEXCOLOR(0xffe462).CGColor,(id)[UIColor clearColor].CGColor];
    layer.locations = @[@(0.4),@(0.5),@(0.6)];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
    _frontView.layer.mask = layer;
    
    layer.position = CGPointMake(-_frontView.bounds.size.width/4.0, _frontView.bounds.size.height/2.0);
}

- (void)iPhoneFadeWithDuration:(NSTimeInterval)duration
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"transform.translation.x";
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(_frontView.bounds.size.width+_frontView.bounds.size.width/2.0);
    basicAnimation.duration = duration;
    basicAnimation.repeatCount = 2;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [_frontView.layer.mask addAnimation:basicAnimation forKey:nil];
}

- (void)editBtnClick
{
    if (_touchEdit) {
        _touchEdit();
    }
}

- (void)setData:(ZZUser *)user {
    _user = user;
    [_frontView.layer removeAllAnimations];
    
    ZZPhoto *photo = user.photos.firstObject;
    BOOL isShow = NO;//(photo == nil || photo.face_detect_status != 3) || ([[ZZUserHelper shareInstance] isUsersAvatarManuallReviewing:user] && ![[ZZUserHelper shareInstance] canShowUserOldAvatarWhileIsManualReviewingg:user]);
    
    NSString *icon = @"icTouxiang";//@"icProfileBlur";
    if ([user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        _attentView.hidden = YES;
        _editBtn.hidden = NO;
        [self createMask];
        [self iPhoneFadeWithDuration:1.5];
    
        if ([user isAvatarManualReviewing]) {
            // 审核中
            if (![user didHaveOldAvatar]) {
                isShow = YES;
                self.realFaceTipsLabel.text = @"头像正在人工审核中，审核通过后正常展示";
            }
        }
        else {
            if (![user didHaveRealAvatar] && ![user didHaveOldAvatar]) {
                isShow = YES;
                self.realFaceTipsLabel.text = @"您的头像未使用本人正脸五官清晰照片，仅显示一张";
            }
            
        }
    }
    else {
        _attentView.hidden = NO;
        _editBtn.hidden = YES;
        if ([user isAvatarManualReviewing]) {
            // 审核中
            if (![user didHaveOldAvatar]) {
                isShow = YES;
                self.realFaceTipsLabel.text = @"头像未使用本人正脸五官清晰照片，仅显示一张";
            }
        }
        else {
            if (![user didHaveRealAvatar] && ![user didHaveOldAvatar]) {
                isShow = YES;
                self.realFaceTipsLabel.text = @"头像未使用本人正脸五官清晰照片，仅显示一张";
            }
        }
    }
    
    self.faceImageView.image = [UIImage imageNamed:icon];
    self.realFaceTipsView.hidden = isShow ? NO : YES;
    
    _attentView.follow_status = user.follow_status;
    if (_user.photos.count) {
        _pageControl.numberOfPages = _user.photos.count;
    }
    else {
        _pageControl.numberOfPages = 1;
    }
    _pageControl.currentPage = 0;
    
    self.attentLabel.text = [NSString stringWithFormat:@"%ld",(long)user.following_count];
    self.fansLabel.text = [NSString stringWithFormat:@"%ld",(long)user.follower_count];
    
    if (user.gender == 2) {
        self.sexLabel.text = @"女";
    }
    else if (user.gender == 1) {
        self.sexLabel.text = @"男";
    }
    else {
        self.sexLabel.text = @"";
    }
    if (user.birthday) {
        self.ageLabel.text = user.generation;
    }
    else {
        self.ageLabel.text = @"";
    }
    if ([ZZUtils isIdentifierAuthority:user]) {
        self.identifierImgView.hidden = NO;
        [self.sexLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_locationImgView.mas_left).offset(21);
        }];
    }
    else {
        self.identifierImgView.hidden = YES;
        [self.sexLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_locationImgView.mas_left);
        }];
    }
    self.locationLabel.text = user.distance?user.distance:user.rent.city.name;
    if (!user.distance && !user.rent.city.name) {
        self.locationLabel.hidden = YES;
//        self.locationLabel.text = @"未出租";
    }
    else {
        self.locationLabel.hidden = NO;
    }
    
    if (user.base_video.status == 1 && photo.face_detect_status == 3) {
        _playButton.hidden = NO;
        
        NSString *time = [NSString stringWithFormat:@"%.0f'", user.base_video.sk.video.time];
        _playButton.normalTitle = time;
        
        [_playButton setImagePosition:LXMImagePositionLeft spacing:6];
        _playButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 10.0);
    }
    else {
        _playButton.hidden = YES;
    }
    
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewMethod
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([[ZZUserHelper shareInstance] isUsersAvatarManuallReviewing:_user]) {
        _pageControl.numberOfPages = 1;
        return 1;
    }
    else {
        if (_user.photos.count > 0) {
            return _user.photos.count;
        }
        else {
            return 1;
        }
    }
//    return _user.displayAlbum.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZRentPageHeadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
    WEAK_SELF();
    
    [cell setUser:_user indexPath:indexPath];
    [cell setPlayVideo:^{
        BLOCK_SAFE_CALLS(weakSelf.playVideo);
    }];
    cell.imageCallBack = ^(UIImage *image) {
        _shareImg = image;
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *a = [collectionView visibleCells];
    UICollectionViewCell *c = [a firstObject];
    NSIndexPath *idx = [collectionView indexPathForCell:c];
    _pageControl.currentPage = idx.row;
}

#pragma mark - UIButtonMethod
- (void)attentCountBtnClcik {
    [ZZHUD showInfoWithStatus:@"为保护用户隐私，关注列表不可见"];
//    if (_touchAttentCount) {
//        _touchAttentCount();
//    }
}

- (void)fansCountBtnClick {
    if (_touchFansCount) {
        _touchFansCount();
    }
}

- (IBAction)playVideoClick:(id)sender {
    BLOCK_SAFE_CALLS(self.playVideo);
}

#pragma mark - lazyload
- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.normalImage = [UIImage imageNamed:@"icdarenShipin"];
        _playButton.normalTitle = @"10'";
        _playButton.normalTitleColor = RGBCOLOR(63, 58, 58);
        _playButton.hidden = YES;
        _playButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_playButton addTarget:self action:@selector(playVideoClick:) forControlEvents:UIControlEventTouchUpInside];
        _playButton.layer.cornerRadius = 14.5;
        _playButton.layer.masksToBounds = YES;
        
    }
    return _playButton;
}

- (ZZRentCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[ZZRentCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = kBGColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[ZZRentPageHeadCollectionViewCell class] forCellWithReuseIdentifier:@"mycell"];
        [self addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return _collectionView;
}

- (UILabel *)attentLabel {
    if (!_attentLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"关注";
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.bottom.mas_equalTo(-12);
        }];
        
        _attentLabel = [[UILabel alloc] init];
        _attentLabel.textColor = [UIColor whiteColor];
        _attentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        _attentLabel.text = @"0";
        [self addSubview:_attentLabel];
        
        [_attentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).offset(3);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
        }];
        
        UIButton *attenBtn = [[UIButton alloc] init];
        [attenBtn addTarget:self action:@selector(attentCountBtnClcik) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:attenBtn];
        
        [attenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_left);
            make.top.mas_equalTo(titleLabel.mas_top).offset(-8);
            make.bottom.mas_equalTo(titleLabel.mas_bottom).offset(8);
            make.right.mas_equalTo(_attentLabel.mas_right).offset(5);
        }];
    }
    return _attentLabel;
}

- (UILabel *)fansLabel
{
    if (!_fansLabel) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_attentLabel.mas_right).offset(10);
            make.centerY.mas_equalTo(_attentLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(1.5, 15.5));
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"粉丝";
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lineView.mas_right).offset(10);
            make.centerY.mas_equalTo(lineView.mas_centerY);
        }];
        
        _fansLabel = [[UILabel alloc] init];
        _fansLabel.textColor = [UIColor whiteColor];
        _fansLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        _fansLabel.text = @"0";
        [self addSubview:_fansLabel];
        
        [_fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).offset(3);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
        }];
        
        UIButton *fansBtn = [[UIButton alloc] init];
        [fansBtn addTarget:self action:@selector(fansCountBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fansBtn];
        
        [fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_left);
            make.top.mas_equalTo(titleLabel.mas_top).offset(-8);
            make.bottom.mas_equalTo(titleLabel.mas_bottom).offset(8);
            make.right.mas_equalTo(_fansLabel.mas_right).offset(5);
        }];
    }
    return _fansLabel;
}

@end
