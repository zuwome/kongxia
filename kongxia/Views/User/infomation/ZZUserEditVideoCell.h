//
//  ZZUserEditVideoCell.h
//  zuwome
//
//  Created by angBiu on 2017/6/20.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSKModel.h"

@interface ZZUserEditVideoCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *outerRingImageView;//外圈颜色
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *playImgView;

@property (nonatomic, assign) BOOL isAddProgress;//是否可以展示下载进度
@property (nonatomic, copy) void (^isUploadVideoBlock)(BOOL uploading);//是否正在上传达人视频

@property (nonatomic, strong) ZZUser *user;

@end
