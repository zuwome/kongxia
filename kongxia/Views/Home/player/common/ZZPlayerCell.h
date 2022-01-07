//
//  ZZPlayerCell.h
//  zuwome
//
//  Created by angBiu on 2016/12/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZFindVideoModel.h"
#import "ZZCommentModel.h"
#import "ZZPlayerTopicView.h"//么么哒提问的话题
@class ZZChatBaseModel;
@interface ZZPlayerCell : UICollectionViewCell <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *processLineView;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, strong) NSMutableArray *contributionArray;
@property (nonatomic, assign) BOOL isMMD;
@property (nonatomic, strong) NSString *skId;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, assign) BOOL isMySelf;
@property (nonatomic, weak) UIViewController *weakCtl;
@property (nonatomic, assign) CGFloat process;
@property (nonatomic, assign) BOOL isLongVideo;//是否是长视屏

@property (nonatomic, copy) dispatch_block_t touchPlayView;
@property (nonatomic, copy) dispatch_block_t loadMore;
@property (nonatomic, copy) dispatch_block_t touchContribution;
@property (nonatomic, copy) void(^viewScroll)(CGFloat y ,BOOL isLongVideo); 
@property (nonatomic, copy) dispatch_block_t gotoReportView;
@property (nonatomic, copy) dispatch_block_t doubleClick;
@property (nonatomic, copy) void(^firstInto)(BOOL isFirst);;//首次进入
@property (nonatomic, copy) void(^touchComment)(ZZCommentModel *model);
@property (nonatomic, copy) void(^touchHead)(NSString *uid);
@property (assign, nonatomic) BOOL isBaseVideo;//代表是看达人视频
@property (strong,nonatomic) ZZMMDModel *mMDDataModel;
@property (strong,nonatomic) ZZSKModel *skDataModel;
@property (nonatomic,strong) ZZPlayerTopicView *playerTopicView;//么么哒的话题
@property (nonatomic, strong) ZZChatBaseModel *chatBaseModel;

/**
 播放视频的URL
 */
@property (nonatomic,strong) NSString *playerUrlStr;
/**
 达人视频是否需要拉伸
 */
@property (assign, nonatomic) BOOL isDarenVideo;

//评论下方的话题
@property (nonatomic,strong) id topicModel;//话题model;

- (void)setData:(ZZFindVideoModel *)model;

- (void)removeMenuView;

- (void)setCommentArray:(NSMutableArray *)array contributions:(NSMutableArray *)contributions noMoreData:(BOOL)noMoreData;

@end
