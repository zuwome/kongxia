//
//  ZZChatCallIphoneManagerNetWork.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZChatCallIphoneManagerNetWork.h"
#import "ZZPublishModel.h"
@implementation ZZChatCallIphoneManagerNetWork

#pragma mark - 连麦
/**
 拨打电话的请求
 @param roomid  当前房间号
 @param uid 对方的uid
 @param paramDic 扩展字段  目前只有订单有
 @param callIphoneStyle 当前拨打电话的方式  100:取消
 @param next 拨打电话的回调
 */
+(void)callIphone:(ChatCallIphoneStyle )callIphoneStyle
              roomid:(NSString *)roomid
                 uid:(NSString *)uid
            paramDic:(NSDictionary *)paramDic
                next:(requestCallback)next {
    
    NSLog(@"PY_当前拨打电话的方式%ld",(long)callIphoneStyle);
    switch (callIphoneStyle) {
        case Cancel_CallIphoneStyle://取消拨打
        {
            [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/room/%@/user/notify",roomid ] params:@{@"type" : [NSString stringWithFormat:@"%ld",(long)callIphoneStyle]} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (next) {
                    next(error,data,task);
                }
            }];

        }
            break;
        case Refused_CallIphoneStyle://拒绝拨打
        {
            
            
        }
            
            break;
        case Chat_AnswerIphoneStyle://达人接通电话
        {}
            
            break;
        case SureCallIphone_MoneyStyle://确认拨打,金钱
        {
            [ZZPublishModel getRoomToken:@{@"uid" : uid} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (next) {
                    next(error,data,task);
                }
            }];
        }
            
            break;
        case SureCallIphone_MeBiStyle://确认拨打,么币
        {
            [ZZPublishModel getRoomToken:@{@"uid" : uid, @"by_mcoin" : @(YES)} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (next) {
                    next(error,data,task);
                }
            }];
        }
            
            break;
        case Busy_CallIphoneStyle: //忙碌状态
        {
            [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/room/%@/user/notify",roomid ] params:@{@"type" : [NSString stringWithFormat:@"%ld",(long)callIphoneStyle]} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (next) {
                    next(error,data,task);
                }
            }];
        }
            break;
        case AcceptOrder_callIphoneStyle://接受派单
        {
            [ZZPublishModel getRoomToken:paramDic next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (next) {
                    next(error,data,task);
                }
            }];
            
        }
            break;
        default:
            break;
    }
}

/**
 拨打电话的方式
 
 @param roomid 当前的房间号码
 @param callIphoneStyleString 拨打电话的方式 cancel 取消
 */

+ (void)callIphoneUpdateStateWithRoomid:(NSString *)roomid callIphoneStyleString:(NSString *)callIphoneStyleString {
    NSLog(@"PY_当前拨打电话的方式_更新状态_%@",callIphoneStyleString);

    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/room/%@/status", roomid] params:@{@"type" : callIphoneStyleString} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
        }
    }];
}


@end
