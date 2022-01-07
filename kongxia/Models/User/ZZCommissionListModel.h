//
//  ZZCommissionListModel.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/7.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZCommissionUserModel;
@class ZZCommissionTodayListModel;
@class ZZCommissionTodayListUserModel;

@interface ZZCommissionListModel : NSObject

@property (nonatomic, assign) NSInteger invite_push;

// 总共获得的收益
@property (nonatomic, copy) NSArray *allData;

// 今日获得的收益
@property (nonatomic, copy) NSArray *todayData;

// 用户数据
@property (nonatomic, copy) NSArray<ZZCommissionUserModel *> *allUserList;

// 有产生金额的
@property (nonatomic, copy) NSArray<ZZCommissionUserModel *> *earnedAllUserList;

//
@property (nonatomic, copy) NSArray<ZZCommissionTodayListModel *> *todayList;

- (void)configureData;

@end

@interface ZZCommissionUserModel : NSObject

@property (nonatomic, assign) double total_money;

@property (nonatomic,   copy) NSString *created_at;

@property (nonatomic,   copy) NSString *from;

@property (nonatomic,   copy) NSString *_id;

@property (nonatomic, assign) NSInteger see_wechat_count;

@property (nonatomic, assign) double see_wechat_money;

@property (nonatomic, assign) NSInteger today_see_wechat_count;

@property (nonatomic, assign) double today_see_wechat_money;

@property (nonatomic, assign) NSInteger be_see_wechat_count;

@property (nonatomic, assign) double be_see_wechat_money;

@property (nonatomic, assign) NSInteger today_be_see_wechat_count;

@property (nonatomic, assign) double today_be_see_wechat_money;

@property (nonatomic, assign) NSInteger order_count;

@property (nonatomic, assign) double order_money;

@property (nonatomic, assign) NSInteger today_order_count;

@property (nonatomic, assign) double today_order_money;

@property (nonatomic, assign) NSInteger be_order_count;

@property (nonatomic, assign) double be_order_money;

@property (nonatomic, assign) NSInteger today_be_order_count;

@property (nonatomic, assign) double today_be_order_money;

@property (nonatomic, assign) NSInteger pd_count;

@property (nonatomic, assign) double pd_money;

@property (nonatomic, assign) NSInteger today_pd_count;

@property (nonatomic, assign) double today_pd_money;

@property (nonatomic, assign) NSInteger gift_count;

@property (nonatomic, assign) double gift_money;

@property (nonatomic, assign) NSInteger today_gift_count;

@property (nonatomic, assign) double today_gift_money;

@property (nonatomic, assign) NSInteger be_gift_count;

@property (nonatomic, assign) double be_gift_money;

@property (nonatomic, assign) NSInteger today_be_gift_count;

@property (nonatomic, assign) double today_be_gift_money;

@property (nonatomic, strong) ZZUser *to;

@property (nonatomic, assign) BOOL shouldShowDetails;

@end

@interface ZZCommissionTodayListModel : NSObject

@property (nonatomic, strong) ZZCommissionTodayListUserModel *_id;

@property (nonatomic, assign) NSInteger today_count;

@property (nonatomic, assign) double agency_price;

@end

@interface ZZCommissionTodayListUserModel : NSObject

@property (nonatomic, copy) NSString *to;

@property (nonatomic, assign) NSInteger type;


@end
