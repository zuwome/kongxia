//
//  ZZCommissionListModel.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/7.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCommissionListModel.h"

@implementation ZZCommissionListModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"allUserList" : [ZZCommissionUserModel class],
             @"todayList" : [ZZCommissionTodayListModel class]
             };
}

- (void)configureData {
    for (ZZCommissionTodayListModel *todayModel in _todayList) {
        for (ZZCommissionUserModel *userModel in _earnedAllUserList) {
            if ([todayModel._id.to isEqual:userModel.to.uuid]) {
                switch (todayModel._id.type) {
                    case 0: {
                        // 被查看微信
                        userModel.today_be_see_wechat_count = todayModel.today_count;
                        userModel.today_be_see_wechat_money = todayModel.agency_price;
                        break;
                    }
                    case 1: {
                        // 查看微信
                        userModel.today_see_wechat_count = todayModel.today_count;
                        userModel.today_see_wechat_money = todayModel.agency_price;
                        break;
                    }
                    case 2: {
                        // 线下邀约
                        userModel.today_order_count = todayModel.today_count;
                        userModel.today_order_money = todayModel.agency_price;
                        break;
                    }
                    case 3: {
                        // 被线下邀约
                        userModel.today_be_order_count = todayModel.today_count;
                        userModel.today_be_order_money = todayModel.agency_price;
                        break;
                    }
                    case 4: {
                        // 通告
                        userModel.today_pd_count = todayModel.today_count;
                        userModel.today_pd_money = todayModel.agency_price;
                        break;
                    }
                    case 5: {
                        // 送礼物
                        userModel.today_gift_count = todayModel.today_count;
                        userModel.today_gift_money = todayModel.agency_price;
                        break;
                    }
                    case 6: {
                        // 被送礼物
                        userModel.today_be_gift_count = todayModel.today_count;
                        userModel.today_be_gift_money = todayModel.agency_price;
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
        }
    }
}

@end

@implementation ZZCommissionUserModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"to" : [ZZUser class],
             };
}

@end

@implementation ZZCommissionTodayListModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"_id" : [ZZCommissionTodayListModel class],
             };
}

@end

@implementation ZZCommissionTodayListUserModel


@end
