//
//  ZZChatViewController.h
//  zuwome
//
//  Created by wlsy on 16/1/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatBaseViewController.h"
#import "ZZTaskConfig.h"
/**
 *  聊天界面
 */
@class ZZChatViewController;
@protocol ZZChatViewControllerDelegate <NSObject>

- (void)controller:(ZZChatViewController *)controller chatDidPickUser:(ZZUser *)user;

@end

@interface ZZChatViewController : ZZChatBaseViewController

@property (nonatomic, weak) id<ZZChatViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, copy) dispatch_block_t statusChange;

@property (nonatomic, assign) BOOL fromSnatchList;//是否是线下抢单列表跳过来的

@property (nonatomic,strong)  NSString* lastMessageSendId;//最后会话页面过来的最后一条消息的发送人的id;

//最后一条消息当从会话页面过来的话就要直接返回去
@property (nonatomic,copy)void(^lastMessage)(RCMessage *message);

@property (nonatomic, assign) BOOL shouldShowWeChat;

@property (nonatomic, assign) BOOL shouldShowGift;



/**
从活动进来要显示一个活动的聊天框
 */
- (void)configureTaskFreeModel:(ZZTaskModel *)taskModel;

@end

