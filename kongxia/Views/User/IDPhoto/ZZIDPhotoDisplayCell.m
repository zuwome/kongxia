//
//  ZZIDPhotoDisplayCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/1/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZIDPhotoDisplayCell.h"

@interface ZZIDPhotoDisplayCell ()

@property (nonatomic, strong) UIImageView *userIconImageView;

@end

@implementation ZZIDPhotoDisplayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)idPhoto:(ZZIDPhoto *)photo hasRealAvatar:(BOOL)hasRealAvatar isMyself:(BOOL)isMyself canSeeIDPhoto:(BOOL)canSeeIDPhoto {
    NSString *title = nil;
    BOOL isHidden = YES;
    if (hasRealAvatar) {
        title = @"系统识别头像为本人";
        
        if (isMyself) {
            if (photo.status == 0 || photo.status == 3) {
                isHidden = NO;
                title = @"您已通过系统人脸识别头像为本人";
            }
            else if (photo.status == 1) {
                title = @"您已通过系统人脸识别头像为本人";
                isHidden = NO;
            }
            else if (photo.status == 2) {
                title = @"证件照与头像确认为本人";
                isHidden = NO;
            }
        }
        else {
            if (photo.status == 2) {
                title = @"证件照与头像确认为本人";
                isHidden = NO;
            }
        }
    }
    _titleLabel.text = title;
    
    if (photo.status == 2) {
        _userIconImageView.hidden = NO;
        NSMutableString *pic = photo.pic.mutableCopy;
        if ([pic hasSuffix:@"/blur/70x70"]) {
            [pic replaceOccurrencesOfString:@"/blur/70x70" withString:@"" options:NSCaseInsensitiveSearch | NSBackwardsSearch range:NSMakeRange(0, [pic length])];
        }
        
        [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:pic] completed:nil];
        
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-150.0);
        }];
    }
    else {
        _userIconImageView.hidden = YES;
        
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15.0);
        }];
    }
    
}

#pragma mark - UI
- (void)layout {
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImageView];
    [self addSubview:self.userIconImageView];

    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15.0);
        make.top.equalTo(self).offset(19.0);
        make.size.mas_equalTo(CGSizeMake(16.0, 18.0));
    }];
    
    [_userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15.0);
        make.top.equalTo(self).offset(10.0);
        make.size.mas_equalTo(CGSizeMake(40, 60));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_iconImageView.mas_trailing).offset(3.0);
        make.top.equalTo(_iconImageView);
        make.trailing.equalTo(self).offset(-150.0);
    }];
}

#pragma mark - Setter&Getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"icRlsbYlzly"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIImageView *)userIconImageView {
    if (!_userIconImageView) {
        _userIconImageView = [[UIImageView alloc] init];
        _userIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _userIconImageView.layer.masksToBounds = YES;
    }
    return _userIconImageView;
}

@end
