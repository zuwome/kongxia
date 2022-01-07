//
//  ZZPlayerHelper.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/23.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//用于判断达人视频是否需要拉伸

#import <Foundation/Foundation.h>
#import "ZZPlayerCell.h"

@interface ZZPlayerHelper : NSObject
/**
 当前为达人视频的话,如果达人视频的宽高比大于1.5就高度适配
 不是的话就自适应
 
 @param cell 当前播放的cell
 @return yes 拉伸  NO自适应
 */
+ (BOOL)whenWatchDaRenVideoBacKIsFillScreen:(ZZPlayerCell *)cell withModel:(ZZSKModel *)skModel;
@end
