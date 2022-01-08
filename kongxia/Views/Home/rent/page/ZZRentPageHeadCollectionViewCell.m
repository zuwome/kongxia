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

}

@end
