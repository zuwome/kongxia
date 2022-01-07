//
//  ZZAuthenticationFailedUploadImageView.h
//  zuwome
//
//  Created by 潘杨 on 2018/7/6.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 认证失败上传的图片
 */
@interface ZZAuthenticationFailedUploadImageView : UIView

@property (nonatomic,strong) UIButton *uploadImageButton;

/**
 上传图片的点击事件
 */
@property(nonatomic,copy) void(^uploadImageBlock)(UIButton *sender);

@end
