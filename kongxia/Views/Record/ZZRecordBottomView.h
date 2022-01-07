//
//  ZZRecordBottomView.h
//  zuwome
//
//  Created by angBiu on 2017/5/27.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZRecordBottomView : UIView

@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *selectPhotoBtn;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, assign) NSInteger videoCount;

@property (nonatomic, assign) BOOL deleteSelected;
@property (nonatomic, assign) BOOL doneSelected;
@property (nonatomic, assign) BOOL isHidePhoto;//是否隐藏相册按钮，默认NO

@property (nonatomic, copy) dispatch_block_t touchDelete;
@property (nonatomic, copy) dispatch_block_t touchDone;
@property (nonatomic, copy) void (^selectPhotoBlock)(void);

- (void)hideAllViews;
- (void)showAllViews;
- (void)hideConfigView;//萌颜。美颜按钮
- (void)showConfigView;
- (void)hideOperateView;//删除。提交按钮
- (void)showOperateView;
- (void)showSelectPhotoView;//回删视频段为0的时候

- (void)showVideoCoverIfNeeded;//相册显示视频封面，在有权限的情况下

@end
