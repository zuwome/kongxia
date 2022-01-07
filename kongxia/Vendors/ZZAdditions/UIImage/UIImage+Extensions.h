//
//  UIImage+Extensions.h
//  Cosmetic
//
//  Created by 余天龙 on 16/4/13.
//  Copyright © 2016年 YuTianLong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define stretchImgFromMiddle(img)	[(img) stretchableImageWithLeftCapWidth:(img).size.width / 2 topCapHeight:(img).size.height / 2]

@interface UIImage (Extensions)

+ (UIImage *)drawLineByImageView:(UIImageView *)imageView;

+ (UIImage *)imageFromColor:(UIColor *)color;

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

+ (UIImage *)compressImage:(UIImage *)image allowMaxStoreSize:(CGFloat)maxSize;

+ (UIImage *)convertImageToGreyScale:(UIImage*)image;

- (UIImage *)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size;

- (void)convertToGrayscaleWithCompleteBlock:(void (^)(UIImage *image))completeBlock;

- (UIImage *)resizableImage;
@end
