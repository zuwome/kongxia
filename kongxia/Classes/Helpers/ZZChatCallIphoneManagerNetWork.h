//
//  ZZChatCallIphoneManagerNetWork.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//连麦管理类
#import "ZZRequest.h"

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ChatCallIphoneStyle) {
    Cancel_CallIphoneStyle =100,//取消拨打
    Refused_CallIphoneStyle = 101,    //拒绝拨打
    Chat_AnswerIphoneStyle = 104,//达人接通电话
    SureCallIphone_MoneyStyle =105 , //确认拨打,金钱
    SureCallIphone_MeBiStyle =106,  //确认拨打,么币
    Busy_CallIphoneStyle = 102,       //忙碌状态
    AcceptOrder_callIphoneStyle =200,//接受派单
};

@interface ZZChatCallIphoneManagerNetWork : NSObject


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
             next:(requestCallback)next ;


/**
 拨打电话的方式

 @param roomid 当前的房间号码
 @param callIphoneStyleString 拨打电话的方式 cancel 取消
 */
+ (void)callIphoneUpdateStateWithRoomid:(NSString *)roomid
                  callIphoneStyleString:(NSString *)callIphoneStyleString;


@end
