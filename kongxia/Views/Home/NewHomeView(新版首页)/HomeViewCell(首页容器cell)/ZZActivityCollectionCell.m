//
//  ZZActivityCollectionCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZActivityCollectionCell.h"

@interface ZZActivityCollectionCell ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) ZZActivityBtn *showBtn;

@property (nonatomic, copy) NSArray<UIImageView *> *iconImageViews;

@end

@implementation ZZActivityCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    BOOL isGirl = UserHelper.loginer.gender == 2;
    NSArray<ZZTask *> *activities = _activitityDic[@"tasks"];
    NSInteger count = 0;
    if ([activities isKindOfClass:[NSArray class]]) {
        count = activities.count;
    }
    __block UIView *baseView = self.contentView;
    if (count != 0) {
        CGSize imageSize = CGSizeMake(50.0, 50.0);
        CGFloat imageToTop = isGirl ? 40.0 : 52.0;
        [_iconImageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (activities.count == 0) {
                imageView.hidden = YES;
            }
            else {
                if (idx > count - 1) {
                    imageView.hidden = YES;
                }
                else {
                    ZZTask *task = activities[idx];
                    if (count == 1) {
                        if (idx == 0) {
                            imageView.frame = CGRectMake(self.width * 0.5 - imageSize.width * 0.5, imageToTop, imageSize.width, imageSize.height);
                            [imageView sd_setImageWithURL:[NSURL URLWithString:[task.from displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                UIImage *roundImage = [image imageAddCornerWithRadius:30 andSize:imageView.size];
                                imageView.image = roundImage;
                            }];
                            imageView.hidden = NO;
                        }
                        else {
                            imageView.hidden = YES;
                        }
                    }
                    else if (count == 2) {
                        if (idx == 0) {
                            imageView.frame = CGRectMake(self.width * 0.5 - 40, 52.0, imageSize.width, imageSize.height);
                        }
                        else if (idx == 1) {
                            imageView.frame = CGRectMake(self.width * 0.5 - 6, 52.0, imageSize.width, imageSize.height);
                        }
                        
                        if (idx < count) {
                            imageView.hidden = NO;
                            [imageView sd_setImageWithURL:[NSURL URLWithString:[task.from displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                UIImage *roundImage = [image imageAddCornerWithRadius:30 andSize:imageView.size];
                                imageView.image = roundImage;
                            }];
                        }
                        else {
                            imageView.hidden = YES;
                        }
                    }
                    else {
                        if (idx == 0) {
                            imageView.frame = CGRectMake(self.width * 0.5 - imageSize.width * 0.5 - 34, 52.0, imageSize.width, imageSize.height);
                        }
                        else if (idx == 1) {
                            imageView.frame = CGRectMake(self.width * 0.5 - imageSize.width * 0.5, 52.0, imageSize.width, imageSize.height);
                        }
                        else {
                            imageView.frame = CGRectMake(self.width * 0.5 + 8.5, 52.0, imageSize.width, imageSize.height);
                        }
                        
                        imageView.hidden = NO;
                        [imageView sd_setImageWithURL:[NSURL URLWithString:[task.from displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                            UIImage *roundImage = [image imageAddCornerWithRadius:30 andSize:imageView.size];
                            imageView.image = roundImage;
                        }];
                    }
                }
            }
        }];
        baseView = self.iconImageViews.firstObject;
    }
    else {
        [_iconImageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
    }
    if (count == 0 && isGirl) {
        _titleLabel.hidden = YES;
    }
    else {
        _titleLabel.hidden = NO;
    }
    
    if (count != 0 && !isGirl) {
        _subTitleLabel.hidden = YES;
    }
    else {
        _subTitleLabel.hidden = NO;
    }
    
    if ((count == 0 && isGirl) || (count != 0 && !isGirl)) {
        _showBtn.hidden = NO;
    }
    else {
        _showBtn.hidden = YES;
    }
    
    _titleLabel.textColor = RGBACOLOR(255, 255, 255, 0.8);
    _subTitleLabel.textColor = RGBCOLOR(255, 255, 255);
    if (!isGirl) {
        if (count == 0) {
            _subTitleLabel.textColor = RGBACOLOR(255, 255, 255, 0.8);
            _titleLabel.textColor = RGBCOLOR(255, 255, 255);
            
            [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(9.5);
                make.right.equalTo(self.contentView).offset(-9.5);
                make.top.equalTo(self.contentView).offset(95);
            }];
            [_subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(9.5);
                make.right.equalTo(self.contentView).offset(-9.5);
                make.top.equalTo(_titleLabel.mas_bottom).offset(16.0);
            }];
        }
        else {
            [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(9.5);
                make.right.equalTo(self.contentView).offset(-9.5);
                make.top.equalTo(baseView.mas_bottom).offset(14);
            }];
            
            [_showBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(_titleLabel.mas_bottom).offset(19.5);
                make.size.mas_equalTo(CGSizeMake(80, 32));
            }];
        }
    }
    else {
        if (count == 0) {
            [_subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(9.5);
                make.right.equalTo(self.contentView).offset(-9.5);
                make.top.equalTo(self.contentView).offset(95.0);
            }];
            
            [_showBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
                make.top.equalTo(_subTitleLabel.mas_bottom).offset(35.5);
                make.size.mas_equalTo(CGSizeMake(80, 32));
            }];
        }
        else {
            [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(9.5);
                make.right.equalTo(self.contentView).offset(-9.5);
                make.top.equalTo(baseView.mas_bottom).offset(12);
            }];
            
            [_subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(9.5);
                make.right.equalTo(self.contentView).offset(-9.5);
                make.top.equalTo(_titleLabel.mas_bottom).offset(16.0);
            }];
        }
    }
    
    NSString *title = nil;
    NSString *subTitle1 = @"", *subTitle2 = @"";
    NSMutableString *subTitle = [NSMutableString new];
    NSString *btnTitle = nil;
    if (isGirl) {
        if (count == 0) {
            title = _activitityDic[@"girlTipTopTitleTextArr"][0];
            subTitle1 = _activitityDic[@"girlTipTopTextArr"][0] ?: @"";
            subTitle2 = _activitityDic[@"girllTipBotmTextArr"][0] ?: @"";
            btnTitle = _activitityDic[@"girlBtn"][0];
        }
        else if (count == 1) {
            title = _activitityDic[@"girlTipTopTitleTextArr"][1];
            subTitle1 = _activitityDic[@"girlTipTopTextArr"][1] ?: @"";
            subTitle2 = _activitityDic[@"girllTipBotmTextArr"][1] ?: @"";
            btnTitle = _activitityDic[@"girlBtn"][1];
        }
        else {
            title = _activitityDic[@"girlTipTopTitleTextArr"][2];
            subTitle1 = _activitityDic[@"girlTipTopTextArr"][2] ?: @"";
            subTitle2 = _activitityDic[@"girllTipBotmTextArr"][2] ?: @"";
            btnTitle = _activitityDic[@"girlBtn"][2];
        }
    }
    else {
        if (count == 0) {
            title = _activitityDic[@"manTipTopTitleTextArr"][0];
            subTitle1 = _activitityDic[@"manTipTopTextArr"][0] ?: @"";
            subTitle2 = _activitityDic[@"manlTipBotmTextArr"][0] ?: @"";
            btnTitle = _activitityDic[@"manBtn"][0];
        }
        else if (count == 1) {
            title = _activitityDic[@"manTipTopTitleTextArr"][1];
            subTitle1 = _activitityDic[@"manTipTopTextArr"][1] ?: @"";
            subTitle2 = _activitityDic[@"manlTipBotmTextArr"][1] ?: @"";
            btnTitle = _activitityDic[@"manBtn"][1];
        }
        else {
            title = _activitityDic[@"manTipTopTitleTextArr"][2];
            subTitle1 = _activitityDic[@"manTipTopTextArr"][2] ?: @"";
            subTitle2 = _activitityDic[@"manlTipBotmTextArr"][2] ?: @"";
            btnTitle = _activitityDic[@"manBtn"][2];
        }
    }
    _titleLabel.text = title;
    
    [subTitle appendString:subTitle1];
    if (subTitle.length > 0 && subTitle2.length > 0) {
        [subTitle appendString:@"\n"];
    }
    [subTitle appendString:subTitle2];
    
    if (isGirl && count > 0 && [_activitityDic[@"showIcon"] integerValue] == 1 && ([_activitityDic[@"iconUrl"] isKindOfClass:[NSString class]] && [_activitityDic[@"iconUrl"] length] > 0)) {
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:_activitityDic[@"iconUrl"]] options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (!error) {
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:subTitle];
                
                NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
                imageAttachment.image = image;
                imageAttachment.bounds = CGRectMake(10.0, -2.0, 11.5, 11.5);
                NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
                
                [str appendAttributedString:attachString];
                _subTitleLabel.attributedText = str;
            }
            else {
                _subTitleLabel.text = subTitle;
            }
        }];
    }
    else {
        _subTitleLabel.text = subTitle;
    }
    _showBtn.titleLabel.text = btnTitle;
}

- (void)layout {
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.showBtn];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    NSMutableArray *imageViews = @[].mutableCopy;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 25.0;
        imageView.layer.borderWidth = 2;
        imageView.layer.borderColor = ColorWhite.CGColor;
        imageView.hidden = YES;
        [self.contentView addSubview:imageView];
        [imageViews addObject:imageView];
    }
    _iconImageViews = imageViews.copy;
}

#pragma mark - getters and setters
- (void)setActivitityDic:(NSDictionary *)activitityDic {
    _activitityDic = activitityDic;
    [self configureData];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBACOLOR(255, 255, 255, 0.8);
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"发布了新的活动";
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = RGBCOLOR(255, 255, 255);
        _subTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.numberOfLines = 2;
        _subTitleLabel.text = @"发布自己指定想要的活动分享时间 赚取收益";
    }
    return _subTitleLabel;
}

- (ZZActivityBtn *)showBtn {
    if (!_showBtn) {
        _showBtn = [[ZZActivityBtn alloc] init];
    }
    return _showBtn;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"bacground"];
    }
    return _bgImageView;
}


@end

@implementation ZZActivityBtn

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
        self.backgroundColor = RGBCOLOR(244, 203, 7);
        self.layer.cornerRadius = 16;
    }
    return self;
}

- (void)layout {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.imageView];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15.5);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_titleLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(5, 10));
    }];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _titleLabel.text = @"去看看";
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"invalidName11"];
    }
    return _imageView;
}

@end
