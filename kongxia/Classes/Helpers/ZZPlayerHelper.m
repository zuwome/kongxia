//
//  ZZPlayerHelper.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/23.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPlayerHelper.h"
@implementation ZZPlayerHelper

/**
 当前为达人视频的话,如果达人视频的宽高比大于1.5就高度适配
 不是的话就自适应
 
 @param cell 当前播放的cell
 @return yes 拉伸  NO自适应
 */
+ (BOOL)whenWatchDaRenVideoBacKIsFillScreen:(ZZPlayerCell *)cell withModel:(ZZSKModel *)skModel {
    CGFloat videoWidth = 0.0;//视频的宽
    CGFloat videoHeight = 0.0;//视频的高
    videoHeight = skModel.video.height;
    videoWidth = skModel.video.width;
   
    float proportion = videoHeight/videoWidth;//高宽比
    if (proportion>=1.5) {
        return YES;
    }else{
        return NO;
    }
    
}
@end
