//
//  ZZThemePictureCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCircleProgressView.h"

#define ThemePictureIdentifier @"ThemePictureIdentifier"

typedef NS_ENUM(NSInteger, ThemePictureType) {
    ThemePictureTypeCover = 0,  //封面
    ThemePictureTypePicture,    //非封面
    ThemePictureTypeAdd         //图片添加
};

@interface ZZThemePictureCell : UICollectionViewCell

@property (nonatomic, assign) ThemePictureType cellType;

@property (nonatomic, strong) UIImageView *themePicture;

@property (nonatomic, copy) void(^addPicture)(void);      //添加图片回调
@property (nonatomic, copy) void(^deletePicture)(void);   //删除图片回调
@property (nonatomic, strong) ZZCircleProgressView *progressView;

@end
