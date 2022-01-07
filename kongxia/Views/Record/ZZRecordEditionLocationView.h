//
//  ZZRecordEditionLocationView.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/7.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 编辑界面定位
 */
@interface ZZRecordEditionLocationView : UIView
@property (nonatomic, strong) UILabel *titleLabel;//地点

@property (nonatomic, copy) dispatch_block_t tapSelf;//选中的点击时间
@property (nonatomic, strong,readonly) NSString *loc_name;//要上传的地点
@property (nonatomic,assign) BOOL isNoTop;//表示当前没有选定位

@property (nonatomic,assign) float currentWidth;
/**
 删除回调
 */
@property (nonatomic, copy) dispatch_block_t delegateButtionCallback;
@property (nonatomic, strong) NSString *titleLabelString;//地点
@end
