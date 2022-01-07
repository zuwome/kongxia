//
//  ZZRecordStickerChooseView.h
//  zuwome
//
//  Created by angBiu on 2016/12/13.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZZRecordStickerModel.h"

@class ZZRecordChooseView;

@protocol ZZRecordChooseDelegate <NSObject>

- (void)chooseView:(ZZRecordChooseView *)chooseView isViewUp:(BOOL)isViewUp;
@end

/**
 滤镜和瘦脸配置
 */
@interface ZZRecordChooseView : UIView

@property (nonatomic, weak) id<ZZRecordChooseDelegate>delegate;
@property (nonatomic, assign) BOOL isViewUp;
@property (nonatomic, strong) NSMutableArray *stickerDataArray;//返回的数据数组
@property (nonatomic, strong) NSString *stickerVersion;
@property (nonatomic, copy) dispatch_block_t showRedPoint;
@property (nonatomic, copy) dispatch_block_t hideRedPoint;

- (void)viewUp;
- (void)viewDown;

// 保存当前选中的贴纸
- (void)saveRecordStickerModel:(ZZRecordStickerModel *)model;

// 删除当前保存的贴纸
- (void)removeRecordStickerModel;

// 获取保存下来的贴纸
- (ZZRecordStickerModel *)fetchRecordStickerModel;


@end
