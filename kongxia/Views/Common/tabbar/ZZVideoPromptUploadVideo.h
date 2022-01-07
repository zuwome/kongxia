//
//  ZZVideoPromptUploadVideo.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/5.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//视屏选相册的提示

#import <UIKit/UIKit.h>

@interface ZZVideoPromptUploadVideo : UIView
/**
 
 视屏选相册的提示
 @param showTime  要展示的时间
 @param showView  要展示的showView父视图
 @param showTitle 提示的文字
 @param completionCallBack 动画结束的回调
 */
+ (ZZVideoPromptUploadVideo *)showVideoPromptUploadVideoWithShowTime:(NSInteger)showTime
                                      ShowView:(UIView *)showView
                                     showTitle:(NSString *)showTitle
                                     completion:(void(^)(void))completionCallBack;

@end
