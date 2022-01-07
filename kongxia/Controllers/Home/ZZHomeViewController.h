//
//  ZZHomeViewController.h
//  zuwome
//
//  Created by angBiu on 16/7/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZHomeNotificationInfoView.h"
#import "ZZLiveStreamViewController.h"
/**
 *  首页
 */
@interface ZZHomeViewController : ZZViewController

@property (nonatomic, strong) ZZHomeNotificationInfoView *infoView;
@property (nonatomic, assign) BOOL showLiveStream;
@property (nonatomic, strong) ZZLiveStreamViewController *livestreamCtl;

// 单例
+ (id)sharedInstance;

- (void)moveBar:(CGFloat)offset;
- (void)showOrHideBar:(BOOL)isShow;
- (void)hideNotificationInfoView;
- (void)labelClick:(NSInteger)index;

@end
