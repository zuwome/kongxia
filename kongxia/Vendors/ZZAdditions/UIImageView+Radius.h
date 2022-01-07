//
//  UIImageView+Radius.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/6.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Radius)

- (void)loadImage:(NSString *)url placeHolder:(NSString *)placeHolderStr radius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
