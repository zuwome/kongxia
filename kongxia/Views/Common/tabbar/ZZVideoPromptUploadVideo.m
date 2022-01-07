//
//  ZZVideoPromptUploadVideo.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/5.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZVideoPromptUploadVideo.h"

@implementation ZZVideoPromptUploadVideo

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
                                                            completion:(void(^)(void))completionCallBack {
    
    ZZVideoPromptUploadVideo *currentView = [[ZZVideoPromptUploadVideo alloc]init];
    [currentView       showVideoPromptUploadVideoWithShowTime:showTime
                       ShowView:showView
                       showTitle:showTitle
                        completion:^{
                            if (completionCallBack) {
                                completionCallBack();
                            }
                        }];
    return currentView;
    
}

- (void)showVideoPromptUploadVideoWithShowTime:(NSInteger)showTime
                                      ShowView:(UIView *)showView
                                      showTitle:(NSString *)showTitle
                                      completion:(void(^)(void))completionCallBack{
    if (showView==nil) {
        showView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    }
    [showView addSubview:self];
    self.backgroundColor = RGBCOLOR(254, 98, 61);
    self.frame = CGRectMake(0, 0, showView.width, 0);
    if (isIPhoneX) {
        self.height = 22+44;
    }else {
        self.height = 22;
    }

    UILabel *showTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height- 22, SCREEN_WIDTH, 22)];
    [self addSubview:showTitleLab];
    [self bringSubviewToFront:showTitleLab];
    showTitleLab.text = showTitle;
    showTitleLab.font = [UIFont systemFontOfSize:13];
    showTitleLab.textColor = RGBCOLOR(255, 255, 255);
    showTitleLab.textAlignment = NSTextAlignmentCenter;

    
    [NSObject asyncWaitingWithTime:showTime completeBlock:^{
        if (completionCallBack) {
            completionCallBack();
        }
        [self removeFromSuperview];
    }];
    
//    [UIView animateWithDuration:2 animations:^{
//
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:1 delay:showTime options:(UIViewAnimationOptionTransitionFlipFromTop) animations:^{
//           showView.mj_y = 0;
//            if (completionCallBack) {
//                completionCallBack();
//            }
//        } completion:^(BOOL finished) {
//
//            [self removeFromSuperview];
//        }];
//    }];
    
   

}
@end
