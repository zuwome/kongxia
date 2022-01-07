//
//  ZZLiveStreamConnectGuide.h
//  zuwome
//
//  Created by angBiu on 2017/8/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 首次视频1v1 引导  3.4.0 版本取消了
 */
@interface ZZLiveStreamConnectGuide : UIView

/**
 当用户第一次进入的时候调用的引导
 */
+ (void)liveStreamConnectGuideWhenUserFirstInto;
@end
