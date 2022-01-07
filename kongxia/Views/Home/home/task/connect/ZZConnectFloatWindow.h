//
//  ZZConnectFloatWindow.h
//  zuwome
//
//  Created by angBiu on 2017/7/17.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZLiveStreamConnectViewController;
/**
 小视频浮窗
 */
@interface ZZConnectFloatWindow : UIView

@property (nonatomic, assign) BOOL viewShow;
@property (nonatomic, assign) BOOL acceped;
@property (nonatomic, assign) BOOL rechargeing;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) ZZLiveStreamConnectViewController *callIphoneViewController;//视屏通话的控制器
+ (ZZConnectFloatWindow *)shareInstance;
- (void)show;
- (void)remove:(BOOL)animate;

@end
