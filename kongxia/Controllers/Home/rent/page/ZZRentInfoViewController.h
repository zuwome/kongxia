//
//  ZZRentInfoViewController.h
//  zuwome
//
//  Created by angBiu on 16/8/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentTypeBaseViewController.h"
#import "ZZWeiChatEvaluationModel.h"
/**
 *  他人页信息列表
 */
@interface ZZRentInfoViewController : ZZRentTypeBaseViewController

@property (nonatomic, assign) BuySource source;

@property (nonatomic, assign) BOOL isClickType;//防止个人信息高度不够切换到其他type不能通过点击切回信息页
@property (assign, nonatomic) BOOL fromLiveStream;//只显示底部跟她视频
@property (nonatomic, assign) BOOL showWX;//是否是聊天界面里面点查看微信
@property (nonatomic, assign) BOOL showSignUpBtn; 
@property (nonatomic, assign) BOOL scrollLock;  //滑动锁
@property (nonatomic, copy) dispatch_block_t pushBarHide;
@property (nonatomic, copy) dispatch_block_t pushCallBack;
@property (nonatomic, copy) dispatch_block_t scrollToDynamic;
@property (nonatomic, copy) dispatch_block_t gotoEdit;
@property (nonatomic, copy) dispatch_block_t scrollToTop;   //列表滑动到顶部时回调
@property (nonatomic, copy) void(^didBoughtWechatBlock)(BOOL didBoughtWechat) ; // 购买了微信
@property (nonatomic, copy) void(^gotoSkillDetail)(ZZTopic *topic); //跳转技能详情
@property (nonatomic, copy) void(^gotoPhotoMangerView)(void); //跳转技能详情
@property (nonatomic, copy) void(^goDate)(void); //约她
- (void)setData:(ZZUser *)user;
- (void)setComments:(NSMutableArray *)comments;

@end
