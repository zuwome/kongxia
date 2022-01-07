//
//  UIImageView+Radius.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/6.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "UIImageView+Radius.h"
@implementation UIImageView (Radius)

- (void)loadImage:(NSString *)url placeHolder:(NSString *)placeHolderStr radius:(CGFloat)radius {
    if (radius == CGFLOAT_MIN) {
        radius = self.frame.size.width * 0.5;
    }
    
    NSURL *imageURL = [NSURL URLWithString:url];
    if (radius) {
//        NSString *cachedURLStr = [url stringByAppendingString:@"radiusCache"];
//        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cachedURLStr];
//        if (cachedImage) {
//            self.image = cachedImage;
//        }
//        else {
            [self sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:placeHolderStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    UIImage *radiusImage = [UIImage createRoundedRectImage:image size:self.frame.size roundRadius:radius];
                    self.image = radiusImage;
//                    [[SDImageCache sharedImageCache] storeImage:radiusImage forKey:cachedURLStr completion:nil];
                    
                    //清除原有非圆角图片缓存
//                    [[SDImageCache sharedImageCache] removeImageForKey:url withCompletion:nil];
                }
            }];
//        }
    }
    else {
        [self sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:placeHolderStr]];
    }
}


@end
