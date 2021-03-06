//
//  ZZRentPageHeadCollectionViewCell.m
//  zuwome
//
//  Created by angBiu on 16/8/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentPageHeadCollectionViewCell.h"
#import "ZZSKModel.h"

@interface ZZRentPageHeadCollectionViewCell ()

@property (nonatomic, strong) UIButton *playButton;//如果有达人视频，则第一个banner显示

@property (nonatomic, strong) UIImageView *blurImageView; //毛玻璃

@end

@implementation ZZRentPageHeadCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    
    return self;
}

- (void)setUser:(ZZUser *)user indexPath:(NSIndexPath *)indexPath {
//    ZZPhoto *photo = user.displayAlbum[indexPath.row];
    ZZPhoto *photo = [[ZZPhoto alloc] init];
    if ([UserHelper isUsersAvatarManuallReviewing:user] && [UserHelper canShowUserOldAvatarWhileIsManualReviewingg:user]) {
        photo.url = user.old_avatar;
    }
    else {
        if (user.photos.count) {
            photo = user.photos[indexPath.row];
        }
        else {
            photo.url = user.avatar;
        }
    }
    [_imgView sd_setImageWithURL:[photo.url qiniuURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (indexPath.row == 0 && image) {
            if (_imageCallBack) {
                _imageCallBack(image);
            }
        }
    }];

//    if (indexPath.row == 0 && user.base_video.status == 1 && photo.face_detect_status == 3) {
//        _playButton.hidden = NO;
//
//        NSString *time = [NSString stringWithFormat:@"%.0f'", user.base_video.sk.video.time];
//        _playButton.normalTitle = time;
//
//        [_playButton setImagePosition:LXMImagePositionLeft spacing:6];
//    }
//    else {
//        _playButton.hidden = YES;
//    }
}

//- (UIButton *)playButton {
//    if (!_playButton) {
//        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _playButton.normalImage = [UIImage imageNamed:@"icdarenShipin"];
//        _playButton.normalTitle = @"10'";
//        _playButton.normalTitleColor = RGBCOLOR(63, 58, 58);
//        _playButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
//        [_playButton addTarget:self action:@selector(playVideoClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        _playButton.layer.cornerRadius = 14.5;
//        _playButton.layer.masksToBounds = YES;
//        
//    }
//    return _playButton;
//}
//
//- (IBAction)playVideoClick:(id)sender {
//    BLOCK_SAFE_CALLS(self.playVideo);
//}

@end
