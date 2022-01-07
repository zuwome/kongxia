//
//  ZZUploadPhotoExampleView.m
//  kongxia
//
//  Created by qiming xiao on 2019/7/31.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZUploadPhotoExampleView.h"

@interface ZZUploadPhotoExampleView ()

@property (nonatomic, assign) PhotoExampleType type;

@property (nonatomic, strong) ZZUploadPhotoExampleTopView *topView;

@property (nonatomic, strong) ZZUploadPhotoExampleBottomView *bottomView;

@end

@implementation ZZUploadPhotoExampleView

+ (instancetype)showPhotos:(PhotoExampleType)type showin:(UIView *)view {
    ZZUploadPhotoExampleView *exampleview = [[ZZUploadPhotoExampleView alloc] initWithType:type];
    
    CGFloat height = 0;
    if (type == PhotoUserInfo) {
        height = 284.5;
    }
    else {
        height = 210.5;
    }
    exampleview.frame = CGRectMake(10.0, SCREEN_HEIGHT, SCREEN_WIDTH - 20, height);
    
    [view addSubview:exampleview];
    return exampleview;
}

- (instancetype)initWithType:(PhotoExampleType)type {
    self = [super init];
    if (self) {
        _type = type;
        [self layout];
    }
    return self;
}

- (void)show {
    CGFloat actionsheetsHeight = isFullScreenDevice ? 220.0 : 200.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.top = SCREEN_HEIGHT - self.height - actionsheetsHeight;//(isFullScreenDevice ? 220.0 : 200.0);
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.top = SCREEN_HEIGHT;
    }];
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(249, 249, 247);
    self.layer.cornerRadius = 12.0;
    self.layer.masksToBounds = YES;
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    
    CGFloat height = 0;
    if (_type == PhotoUserInfo) {
        height = 120;
    }
    else {
        height = 83;
    }
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(height));
    }];

    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(_topView.mas_bottom);
    }];
}

#pragma mark - getters and setters
- (ZZUploadPhotoExampleTopView *)topView {
    if (!_topView) {
        _topView = [[ZZUploadPhotoExampleTopView alloc] initWithType:_type];
    }
    return _topView;
}

- (ZZUploadPhotoExampleBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[ZZUploadPhotoExampleBottomView alloc] initWithType:_type];
    }
    return _bottomView;
}

@end

@interface ZZUploadPhotoExampleTopView ()

@property (nonatomic, assign) PhotoExampleType type;

@end

@implementation ZZUploadPhotoExampleTopView

- (instancetype)initWithType:(PhotoExampleType)type {
    self = [super init];
    if (self) {
        _type = type;
        [self layout];
        [self configure];
    }
    return self;
}

- (void)configure {
    if (_type == PhotoUserInfo) {
        _titleLabel.text = @"优质头像照片";
        _subTitleLabel.text = @"优质真实的头像照片，才会被首页推荐哦";
        [_exampleImageView sd_setImageWithURL:[NSURL URLWithString:@"http://7xwsly.com1.z0.glb.clouddn.com/imgs/touxiang_example_big.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
    }
    else {
        _titleLabel.text = @"优质技能照片标准";
        _subTitleLabel.text = @"优质的技能照片，会为您的首页推荐加分，排名更靠前，获得更多曝光机会";
    }
}

#pragma mark - Layout
- (void)layout {
    if (_type == PhotoUserInfo) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.exampleImageView];
        [self addSubview:self.seperateline];
        
        [_exampleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self).offset(-20.0);
            make.size.mas_equalTo(CGSizeMake(85, 85));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(20.0);
            make.right.equalTo(_exampleImageView.mas_left).offset(-20.0);
        }];
        
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_titleLabel);
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
        }];
        
        [_seperateline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(20.0);
            make.right.equalTo(self).offset(-20.0);
            make.height.equalTo(@1);
        }];
    }
    else {
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(20.0);
            make.right.equalTo(self).offset(-20.0);
        }];
        
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_titleLabel);
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
        }];
    }
    
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = RGBCOLOR(153, 153, 153);
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.numberOfLines = 2;
    }
    return _subTitleLabel;
}

- (UIImageView *)exampleImageView {
    if (!_exampleImageView) {
        _exampleImageView = [[UIImageView alloc] init];
    }
    return _exampleImageView;
}

- (UIView *)seperateline {
    if (!_seperateline) {
        _seperateline = [[UIView alloc] init];
        _seperateline.backgroundColor = RGBCOLOR(230, 230, 230);
    }
    return _seperateline;
}

@end

@interface ZZUploadPhotoExampleBottomView ()

@property (nonatomic, assign) PhotoExampleType type;


@property (nonatomic, assign) CGFloat imageViewWidth;

@end

@implementation ZZUploadPhotoExampleBottomView

- (instancetype)initWithType:(PhotoExampleType)type {
    self = [super init];
    if (self) {
        _type = type;
        [self layout];
        [self configure];
    }
    return self;
}

- (void)configure {
    NSString *url1 = @"";
    NSString *url2 = @"";
    NSString *url3 = @"";
    NSString *url4 = @"";
    
    if (_type == PhotoUserInfo) {
        _titleLabel.text = @"优质头像标准";
        _exampleTitle1Label.text = @"职业装照";
        _exampleTitle2Label.text = @"展现爱好特长";
        _exampleTitle3Label.text = @"半身或全身照";
        _exampleTitle4Label.text = @"健康阳光";
        
        url1 = @"http://7xwsly.com1.z0.glb.clouddn.com/imgs/touxiang_example_small1.png";
        url2 = @"http://7xwsly.com1.z0.glb.clouddn.com/imgs/touxiang_example_small2.png";
        url3 = @"http://7xwsly.com1.z0.glb.clouddn.com/imgs/touxiang_example_small3.png";
        url4 = @"http://7xwsly.com1.z0.glb.clouddn.com/imgs/touxiang_example_small4.png";
    }
    else {
        _exampleTitle1Label.text = @"职业装或证件照";
        _exampleTitle2Label.text = @"展现爱好特长";
        _exampleTitle3Label.text = @"符合技能场景";
        _exampleTitle4Label.text = @"健康阳光";
        
        url1 = @"http://7xwsly.com1.z0.glb.clouddn.com/imgs/jineng_example_small1.png";
        url2 = @"http://7xwsly.com1.z0.glb.clouddn.com/imgs/jineng_example_small2.png";
        url3 = @"http://7xwsly.com1.z0.glb.clouddn.com/imgs/jineng_example_small4.png";
        url4 = @"http://7xwsly.com1.z0.glb.clouddn.com/imgs/jineng_example_small3.png";
    }
    
    [_example1ImageView sd_setImageWithURL:[NSURL URLWithString:url1] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    [_example2ImageView sd_setImageWithURL:[NSURL URLWithString:url2] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    
    }];
    
    [_example3ImageView sd_setImageWithURL:[NSURL URLWithString:url3] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    [_example4ImageView sd_setImageWithURL:[NSURL URLWithString:url4] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
}

#pragma mark - Layout
- (void)layout {
    if (_type == PhotoUserInfo) {
        [self addSubview:self.titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15.0);
            make.left.equalTo(self).offset(20.0);
        }];
    }
    
    [self addSubview:self.example1ImageView];
    [self addSubview:self.exampleTitle1Label];
    [self addSubview:self.example2ImageView];
    [self addSubview:self.exampleTitle2Label];
    [self addSubview:self.example3ImageView];
    [self addSubview:self.exampleTitle3Label];
    [self addSubview:self.example4ImageView];
    [self addSubview:self.exampleTitle4Label];
    
    CGFloat offset = 17.0;
    CGFloat width = (SCREEN_WIDTH - 20 - offset * 5) / 4;
    _imageViewWidth = width;
    [_example1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_type == PhotoUserInfo) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(15.0);
        }
        else {
            make.top.equalTo(self).offset(15.0);
        }
        
        make.left.equalTo(self).offset(20.0);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];
    
    [_exampleTitle1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_example1ImageView);
        make.top.equalTo(_example1ImageView.mas_bottom).offset(8.0);
//        make.bottom.equalTo(self).offset(-20.0);
    }];
    
    [_example2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_example1ImageView);
        make.left.equalTo(_example1ImageView.mas_right).offset(17.0);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];
    
    [_exampleTitle2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_example2ImageView);
        make.centerY.equalTo(_exampleTitle1Label);
    }];
    
    [_example3ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_example2ImageView);
        make.left.equalTo(_example2ImageView.mas_right).offset(17.0);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];
    
    [_exampleTitle3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_example3ImageView);
        make.centerY.equalTo(_exampleTitle1Label);
    }];
    
    [_example4ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_example3ImageView);
        make.left.equalTo(_example3ImageView.mas_right).offset(17.0);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];
    
    [_exampleTitle4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_example4ImageView);
        make.centerY.equalTo(_exampleTitle1Label);
    }];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}

- (UIImageView *)example1ImageView {
    if (!_example1ImageView) {
        _example1ImageView = [[UIImageView alloc] init];
    }
    return _example1ImageView;
}

- (UILabel *)exampleTitle1Label {
    if (!_exampleTitle1Label) {
        _exampleTitle1Label = [[UILabel alloc] init];
        _exampleTitle1Label.textColor = RGBCOLOR(102, 102, 102);
        _exampleTitle1Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        _exampleTitle1Label.textAlignment = NSTextAlignmentCenter;
    }
    return _exampleTitle1Label;
}

- (UIImageView *)example2ImageView {
    if (!_example2ImageView) {
        _example2ImageView = [[UIImageView alloc] init];
    }
    return _example2ImageView;
}

- (UILabel *)exampleTitle2Label {
    if (!_exampleTitle2Label) {
        _exampleTitle2Label = [[UILabel alloc] init];
        _exampleTitle2Label.textColor = RGBCOLOR(102, 102, 102);
        _exampleTitle2Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        _exampleTitle2Label.textAlignment = NSTextAlignmentCenter;
    }
    return _exampleTitle2Label;
}

- (UIImageView *)example3ImageView {
    if (!_example3ImageView) {
        _example3ImageView = [[UIImageView alloc] init];
    }
    return _example3ImageView;
}

- (UILabel *)exampleTitle3Label {
    if (!_exampleTitle3Label) {
        _exampleTitle3Label = [[UILabel alloc] init];
        _exampleTitle3Label.textColor = RGBCOLOR(102, 102, 102);
        _exampleTitle3Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        _exampleTitle3Label.textAlignment = NSTextAlignmentCenter;
    }
    return _exampleTitle3Label;
}

- (UIImageView *)example4ImageView {
    if (!_example4ImageView) {
        _example4ImageView = [[UIImageView alloc] init];
    }
    return _example4ImageView;
}

- (UILabel *)exampleTitle4Label {
    if (!_exampleTitle4Label) {
        _exampleTitle4Label = [[UILabel alloc] init];
        _exampleTitle4Label.textColor = RGBCOLOR(102, 102, 102);
        _exampleTitle4Label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        _exampleTitle4Label.textAlignment = NSTextAlignmentCenter;
    }
    return _exampleTitle4Label;
}

@end
