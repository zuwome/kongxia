//
//  ZZMessageListViewController.h
//  zuwome
//
//  Created by angBiu on 16/7/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZUserInfoModel;
/**
 *  消息列表
 */
@interface ZZMessageListViewController : UIViewController
@property (nonatomic,assign) BOOL isCloseSanChat_WoMan;//女性用户是否关闭了文案
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) dispatch_block_t pushCallBack;
@property (nonatomic,strong) NSDictionary *messageListUIDic;//消息提醒UI样式数据
@property (nonatomic,strong) NSMutableArray *unReadCountNumArray;//消息的具体数量
@property (nonatomic, assign) NSInteger systemUnreadCount;

@property (nonatomic, strong) NSMutableArray *conversationArray;//单聊信息
@property (nonatomic, strong) NSMutableDictionary *userInfoDict;


- (ZZUserInfoModel *)getUserInfoModel:(NSString *)targetId;
- (void)getUnreadCountWithCount:(int)count;
- (void)saveUserInfoDict:(NSDictionary *)aDict;
- (NSDictionary *)getUserInfoDict;
@end

@class ZZMessageListHeaderView;

@protocol ZZMessageListHeaderViewDelegate <NSObject>

- (void)showDetails:(ZZMessageListHeaderView *)view;

- (void)close:(ZZMessageListHeaderView *)view;

@end


@interface ZZMessageListHeaderView : UIView

@property (nonatomic, weak) id<ZZMessageListHeaderViewDelegate> delegate;

@end
