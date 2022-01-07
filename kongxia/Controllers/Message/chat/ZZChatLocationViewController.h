//
//  ZZChatLoacationViewController.h
//  zuwome
//
//  Created by angBiu on 2016/11/9.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"

@class AMapPOI;
/**
 *  聊天发送位置
 */
@interface ZZChatLocationViewController : ZZViewController

@property (nonatomic, copy) void(^locationCallBack)(UIImage *image,CLLocation *location,NSString *name);

@end



@protocol ZZChatLocationSearchedControllerDelegate <NSObject>

- (void)setSelectedLocationWithLocation:(AMapPOI *)poi;

@end

@interface ZZChatLocationSearchedController : UITableViewController

@property (nonatomic, weak) id<ZZChatLocationSearchedControllerDelegate> delegate;

@end
