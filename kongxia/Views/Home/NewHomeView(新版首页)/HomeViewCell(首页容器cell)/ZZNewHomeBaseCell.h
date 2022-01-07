//
//  ZZNewHomeBaseCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZHomeModel.h"

#define HomeBaseCellId      @"HomeBaseCellId"
#define HomePicWheelCellId  @"HomePicWheelCellId"   //首页轮播图
#define HomeTopicCellId     @"HomeTopicCellId"      //首页精选技能主题
#define HomeSubjectCellId   @"HomeSubjectCellId"    //首页精选专题
#define HomeShanZuCellId    @"HomeShanZuCellId"     //首页 闪租、视频
#define HomeServiceCellId   @"HomeServiceCellId"    //首页平台服务
#define HomeContentCellId   @"HomeContentCellId"    //首页内容容器（附近、推荐、新鲜）
#define HomeTaskCellId      @"HomeTaskCellId"
#define HomePostTaskCellId  @"HomePostTaskCellId"
#define ZZHomeCollectionsCellId  @"ZZHomeCollectionsCell"
#define ZZHomeCollectionsNewCellId  @"ZZHomeCollectionsNewCell"

@interface ZZNewHomeBaseCell : UITableViewCell
//Base
+ (instancetype)dequeueReusableCellWithTableView:(UITableView *)tableView andCellIdentifier:(NSString *)cellIdentifier forIndexPath:(NSIndexPath *)indexPath;

//PicWheelCell
@property (nonatomic, strong) NSArray *bannerArray; //banner数据
@property (nonatomic, copy) void(^didSelectAtIndex)(NSInteger index);   //点击banner
//TopicCell
@property (nonatomic, strong) NSArray *topics;      //主题数据
@property (nonatomic, copy) void(^topicChooseCallback)(ZZHomeCatalogModel *topic);   //技能主题选择
//SubjectCell
@property (nonatomic, weak) NSArray *specialTopicArray; //精选专题数据
@property (nonatomic, copy) void(^specialTopicCallback)(ZZHomeSpecialTopicModel *model);    //点击精选专题
@property (nonatomic, copy) void(^signupCallback)(ZZTask *task);
@property (nonatomic, copy) void(^showLocationsCallback)(ZZTask *task);
@property (nonatomic, copy) void(^postTaskCallback)(void);

//ShanzuCell
@property (nonatomic, strong) ZZHomeChatModel *rentOptions;     //首页闪租配置
@property (nonatomic, strong) ZZHomeChatModel *chatOptions;     //首页闪聊配置
@property (nonatomic, strong) ZZTask *taskModel;

@property (nonatomic, copy) void(^shanZuCallback)(void);        //闪租任务
@property (nonatomic, copy) void(^videoCounselCallback)(void);  //视频咨询
//ServiceCell
@property (nonatomic, strong) NSArray *introduceList;           //平台介绍
//contentCell
@property (nonatomic, weak) NSArray *ctlsArray;
@property (nonatomic, copy) void(^didScroll)(CGPoint contentOffset);

- (void)configure:(ZZTask *)model;
@end
