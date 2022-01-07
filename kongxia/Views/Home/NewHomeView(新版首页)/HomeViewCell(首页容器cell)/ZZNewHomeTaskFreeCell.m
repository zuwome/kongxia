//
//  ZZNewHomeTaskFreeCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/8/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZNewHomeTaskFreeCell.h"

@interface ZZNewHomeTaskFreeCell ()

@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, strong) UIImageView *titleImageView;

@property (nonatomic, strong) UIImageView *actionImageView;

@property (nonatomic, strong) UILabel * subtitleLabel;

@property (nonatomic, copy) NSArray<UIImageView *> *iconImageViews;

@end

@implementation ZZNewHomeTaskFreeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    NSArray<ZZTask *> *activities = _activitityDic[@"tasks"];
    NSInteger count = 0;
    if ([activities isKindOfClass:[NSArray class]]) {
        count = activities.count;
    }
    
    [_iconImageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (count == 0) {
            imageView.hidden = YES;
        }
        else if (idx >= count) {
            imageView.hidden = YES;
        }
        else {
            imageView.hidden = NO;
            ZZTask *task = activities[idx];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[task.from displayAvatar]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//                UIImage *roundImage = [image imageAddCornerWithRadius:30 andSize:imageView.size];
//                imageView.image = roundImage;
            }];
        }
    }];
    
    if (count == 0) {
        _bgView.image = [UIImage imageNamed:@"picBgFbhd"];
        _titleImageView.image = [UIImage imageNamed:@"homePostTaskFreeTitle2"];
        _subtitleLabel.text = _activitityDic[@"girlTipTopTextArr"][0] ?: @"";
    }
    else {
        _bgView.image = [UIImage imageNamed:@"picBgFbxhd"];
        _titleImageView.image = [UIImage imageNamed:@"homePostTaskFreeTitle1"];
        _subtitleLabel.text = _activitityDic[@"girlTipTopTextArr"][1] ?: @"";
    }
}

#pragma mark - response method
- (void)showTaskFree {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellGoPostTaskFree:)]) {
        [self.delegate cellGoPostTaskFree:self];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.bgView];
    [_bgView addSubview:self.titleImageView];
    [_bgView addSubview:self.subtitleLabel];
    [_bgView addSubview:self.actionImageView];

    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@(90));
    }];

    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(135.0);
        make.top.equalTo(_bgView).offset(18.5);;
        make.height.equalTo(@(17.5));
    }];

    [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleImageView.mas_bottom).offset(5);
        make.right.equalTo(_bgView).offset(-15);
        make.left.equalTo(_titleImageView);
    }];
    
    [_actionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleImageView);
        make.right.equalTo(_bgView).offset(-14);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    NSMutableArray *imageViews = @[].mutableCopy;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 21.0;
        imageView.layer.borderWidth = 2;
        imageView.layer.borderColor = ColorWhite.CGColor;
        imageView.clipsToBounds = YES;
        imageView.hidden = YES;
        [_bgView addSubview:imageView];
        [imageViews addObject:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bgView);
            make.left.equalTo(_bgView).offset(15 + (31.5 * i));
            make.size.mas_equalTo(CGSizeMake(42.0, 42.0));
        }];
    }
    _iconImageViews = imageViews.copy;
}

#pragma mark - getters and setters
- (void)setActivitityDic:(NSDictionary *)activitityDic {
    _activitityDic = activitityDic;
    [self configureData];
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.backgroundColor = RGBCOLOR(255, 242, 242);
        _bgView.layer.cornerRadius = 3;
        _bgView.image = [UIImage imageNamed:@"picBgFbhd"];
    }
    return _bgView;
}

- (UIImageView *)titleImageView {
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.image = [UIImage imageNamed:@"homePostTaskFreeTitle1"];
    }
    return _titleImageView;
}

- (UIImageView *)actionImageView {
    if (!_actionImageView) {
        _actionImageView = [[UIImageView alloc] init];
        _actionImageView.userInteractionEnabled = YES;
        _actionImageView.image = [UIImage imageNamed:@"icGengduo"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTaskFree)];
        [_actionImageView addGestureRecognizer:tap];
    }
    return _actionImageView;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.numberOfLines = 2;
        _subtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _subtitleLabel.textColor = RGBACOLOR(63, 58, 58, 0.8);
        _subtitleLabel.userInteractionEnabled = YES;
    }
    return _subtitleLabel;
}

@end
