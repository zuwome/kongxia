//
//  ZZShowOriginalImageView.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZShowOriginalImageView.h"
#import <UIButton+WebCache.h>

@interface ZZShowOriginalImageView()
@property (nonatomic,strong) UIButton *imageViewButton;
@end
@implementation ZZShowOriginalImageView

- (void)ShowOriginalImageViewWithImageUrl:(NSURL *)imageUrl viewController:(UIViewController *)viewController{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self addSubview:self.imageViewButton];
    self.imageViewButton.frame = self.frame;
    [self.imageViewButton sd_setImageWithURL:imageUrl forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
         NSLog(@"PY_下载完毕");
    }];
    [self showView:nil];
}
- (UIButton *)imageViewButton {
    if (!_imageViewButton) {
        _imageViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageViewButton addTarget:self action:@selector(clickImageView) forControlEvents:UIControlEventTouchUpInside];
        _imageViewButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageViewButton;
}

- (void)clickImageView {
    [self dissMiss];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
