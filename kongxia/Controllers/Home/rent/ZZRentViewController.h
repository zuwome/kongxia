//
//  ZZNewRentViewController.h
//  zuwome
//
//  Created by MaoMinghui on 2018/10/9.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZWeiChatEvaluationModel.h"
#import "ZZTasks.h"

// 进入个人资料页的下一步操作
typedef NS_ENUM(NSInteger, EntryTarget) {
    TargetNone,
    TargetActivitesRent, // 租他
    TargetNormalTaskSignup, // 报名
    TargetNormalTaskPick, // 选它
    TargetTonggaoPick, // 新通告选它
    TargetBuyWechat, // 买微信
};

@class ZZRentViewController;

@protocol ZZRentViewControllerDelegate <NSObject>

- (void)controller:(ZZRentViewController *)controller didPicked:(ZZUser *)user;

@end

@interface ZZRentViewController : ZZViewController

@property (nonatomic, weak) id<ZZRentViewControllerDelegate> delegate;

@property (nonatomic, assign) EntryTarget entryTarget;

@property (nonatomic, assign) BuySource source;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) ZZUser *user;

@property (nonatomic, assign) BOOL isFromHome;      //从首页进入
@property (nonatomic, assign) BOOL isFromLive;      //只显示底部跟她视频 或 选择线下达人
@property (nonatomic, assign) BOOL isFromFastChat;  //闪聊列表进入
@property (nonatomic, assign) BOOL showWX;          //是否是聊天界面里面点查看微信
//@property (nonatomic, assign) BOOL showSignUpBtn;
//@property (nonatomic, assign) BOOL showPickUp;     // 选它


@property (nonatomic, strong) ZZTaskModel *task;
@property (nonatomic, assign) BOOL isTaskFree;

@property (nonatomic, assign) NSInteger chooseType; //线下选达人列表实时刷新个人页是否可以选TA : 1、选他 2、已选定 3、不可选
@property (nonatomic, copy) dispatch_block_t chooseSnatcher;    //选择达人
//闪租--选择达人 配置参数
@property (nonatomic, strong) NSString *publishId;
@property (nonatomic, assign) BOOL canConnect;
@end

@interface UserInfoReviewInfoCell: ZZTableViewCell

@property (nonatomic, strong) NSString *title;

@end
