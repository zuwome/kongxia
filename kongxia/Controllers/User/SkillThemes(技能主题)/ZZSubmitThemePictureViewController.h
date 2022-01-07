//
//  ZZSubmitThemePictureViewController.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

/**
 *  上传主题图片
 */
#define PictureCollectionFooterHeight 90
#define PictureCollectionItemHeight ((SCREEN_WIDTH - 50) / 3)
@interface ZZSubmitThemePictureViewController : ZZViewController

@property (nonatomic, strong) UICollectionView *picCollect;

@property (nonatomic, strong) void(^savePhotoCallback)(NSArray<ZZPhoto> *photos);

@property (nonatomic, strong) NSMutableArray *pictureArray; //上传成功存储zzphoto，其余存储uiimage

@property (nonatomic, strong) ZZTopic *topic;

- (BOOL)savePhotoManual;    //手动调用 返回图片数据回调

@end
