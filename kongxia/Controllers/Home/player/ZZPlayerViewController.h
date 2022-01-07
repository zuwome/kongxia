//
//  ZZPlayerViewController.h
//  zuwome
//
//  Created by angBiu on 2016/12/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZFindVideoModel.h"
#import "ZZUserVideoListModel.h"
#import "ZZPlayerBottomContentView.h"
#import "ZZPlayerBottomCommentView.h"
#import "ZZRightShareView.h"
#import "ZZPlayerNavigationView.h"
#import "ZZCollectionView.h"
#import "ZZWXPayAlertView.h"


typedef NS_ENUM(NSUInteger, PlayType) {
    PlayTypeFindNew   = 0,
    PlayTypeFindHot,
    PlayTypeRecommend,
    PlayTypeTopicNew,
    PlayTypeTopicHot,
    PlayTypeUserVideo
};;
@class ZZPlayerCell;
@class ZZChatBaseModel;
static NSString *playerCellID = @"palyerCellID";
static NSString *DictComments = @"comments";
static NSString *DictNomoredata = @"nomoredata";
static NSString *DictContributions = @"contributions";
static NSString *DictHaveRequestContribution = @"HaveRequestContribution";
/**
    视频播放页
 */
@interface ZZPlayerViewController : ZZViewController
@property (nonatomic, strong) ZZCollectionView *collectionView;
@property (nonatomic, assign) BOOL isBeDeleted;//是否已被删除
@property (nonatomic, assign) BOOL stillPlayWhenFooterStatusChange;//上啦加载更多
@property (nonatomic, strong) NSMutableDictionary *cacheMessageDict;//存储已经加载过的评论

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSIndexPath *dataIndexPath;
@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *skId;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) ZZFindVideoModel *firstFindModel;
@property (nonatomic, strong) ZZUserVideoListModel *userVideo;
@property (nonatomic, strong) ZZSKModel *firstSkModel;
@property (nonatomic, strong) ZZMMDModel *firstMMDModel;
@property (nonatomic, assign) PlayType playType;
@property (nonatomic, assign) BOOL canLoadMore;
@property (nonatomic, assign) BOOL canPop;//点播放页视频发布者头像
@property (nonatomic, assign) BOOL fromAnswer;
@property (nonatomic, assign) BOOL popNotHide;//推送过来的页面是否隐藏导航栏
@property (assign, nonatomic) BOOL fromLiveStream;//选择达人到个人然后过来的不可以进行其他操作
@property (assign, nonatomic) BOOL isShowTextField;//是否主动调起评论textField，默认NO
@property (assign, nonatomic) BOOL isShowNotInterested;
@property (assign, nonatomic) BOOL isShowBlackList;
@property (assign, nonatomic) BOOL isBaseVideo;//代表是看达人视频
@property (assign, nonatomic) BOOL isFromChat;//聊天的视频

//@property (nonatomic, strong) ZZPlayerBottomContentView *contentView;
@property (nonatomic, strong) ZZPlayerBottomCommentView *commentView;
@property (nonatomic, assign) BOOL isScrolling;//是否在滚动
@property (nonatomic, strong) ZZChatBaseModel *chatBaseModel;
@property (nonatomic, strong) ZZSKModel *currentSkModel;
@property (nonatomic, strong) ZZMMDModel *currentMMDModel;
@property (nonatomic, strong) ZZRightShareView *shareView;
@property (nonatomic, strong) ZZFindVideoModel *findModel;
@property (nonatomic, strong) ZZSKDetailModel *skDetailModel;
@property (nonatomic, strong) ZZMemedaModel *mmdDetailModel;
@property (nonatomic, strong) ZZPlayerNavigationView *navigationView;//导航栏view
@property (nonatomic, strong) ZZUser *rentUser; //视频对应的用户，他人，也可能是自己
@property (nonatomic, assign) BOOL isShowWXCopyView;//当前是否已经显示着查看微信view，防止弹多次窗口
@property (nonatomic, strong) ZZPlayerCell *playingCell;

@property (nonatomic, strong) ZZWXPayAlertView *wxAlertView;
@property (nonatomic, assign) BOOL isPushView;//是否是push到下一个页面再返回播放的(et:赏金贡献榜)
@property (nonatomic, assign) BOOL scrollCannotPlay;//发现页进来是否已经滚动到视频所在位置了(防止一进来播放两次视频)
@property (nonatomic, assign) BOOL viewDidAppear;//视图出现
@property (nonatomic, assign) BOOL noMoreData;//加载到没数据了
@property (nonatomic, assign) BOOL isLoadingData;//是否在加载数据
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSIndexPath *currentVideoPath;

@property (nonatomic, copy) dispatch_block_t deleteCallBack;
@property (nonatomic, copy) dispatch_block_t buyWxCallBack;
@property (nonatomic, copy) dispatch_block_t notInterstedCallBack;
@property (nonatomic, copy) void(^vBannedCallBack)(NSString *userID);

- (void)setCellData:(ZZPlayerCell *)cell dict:(NSMutableDictionary *)dict;
/**
 如果是全屏的长视频不处理,如果是短的视屏
 */
- (void)dealWithContentViewWhenFirstIntoPlayer:(BOOL)isShow;

- (NSMutableDictionary *)getCurrentDictionary;
- (void)gotoUserPageWithUid:(NSString *)uid;



- (void)gotoContributionView;

- (void)viewOffset:(CGFloat )cellY isLongVideo:(BOOL)isLongVideo;

- (void)oneClickTableView;

- (void)doubleClickTableView;

-(void)handleQuickScroll;


- (void)playWithPlayerCell:(ZZPlayerCell *)cell;
- (void)createAlertView;
- (void)showWXNumber;
- (void)managerData;
//底部和顶部赋值
- (void)setInfomation;
- (void)playVideoWithPlayerCell:(ZZPlayerCell *)cell;
- (void)managerViewcontrollers;
- (NSString *)getCurrentCachekey;
- (void)resetData;
-(void)stopPlay;
@end
