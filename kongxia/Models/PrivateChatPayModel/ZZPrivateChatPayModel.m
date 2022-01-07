//
//  ZZPrivateChatPayModel.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPrivateChatPayModel.h"

@implementation ZZPrivateChatPayModel
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"version":@"chatUserVersion"}];
}

//用户的性别
- (int)gender {
    return  [ZZUserHelper shareInstance].loginer.gender;
}


/**
 是否检测违禁词版本

 @return YES 是
 */
- (BOOL)isThanCheckVersion {
    NSArray *array = [self.chatUserVersion componentsSeparatedByString:@"."];
    
    switch (array.count) {
        case 1:
        {
            NSString *first = array[0];
            if ([first integerValue] <= 3) {
                return NO;
            } else {
                return YES;
            }
        }
            break;
        case 2:
        {
            NSString *first = array[0];
            NSString *second = array[1];
            if ([first integerValue] < 3) {
                return NO;
            } else if ([first integerValue] == 3 && [second integerValue] < 4) {
                return NO;
            } else {
                return YES;
            }
        }
            break;
        case 3:
        {
            NSString *first = array[0];
            NSString *second = array[1];
            NSString  *thred = array[2];
            if ([first integerValue] < 3) {
                return NO;
            } else if ([first integerValue] == 3 && [second integerValue] < 4) {
                return NO;
            } else if ([first integerValue] == 3 && [second integerValue] == 4 && [thred integerValue] < 3){
                return NO;
            } else {
                return YES;
            }
        }
            break;
        default:
            if (array.count <= 0) {
                return NO;
            } else {
                NSString *first = array[0];
                NSString *second = array[1];
                NSString  *thred = array[2];
                if ([first integerValue] < 3) {
                    return NO;
                } else if ([first integerValue] == 3 && [second integerValue] < 4) {
                    return NO;
                } else if ([first integerValue] == 3 && [second integerValue] == 4 && [thred integerValue] < 3) {
                    return NO;
                } else {
                    return YES;
                }
            }
            break;
    }
}


/**
 私聊付费 在3.4.0 才开始
 */
- (BOOL)chatUserVersionIsLow {
    if ([ZZUtils compareVersionFrom:@"3.4.0" to:self.chatUserVersion] == NSOrderedDescending) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isPay {
    if (!self.globaChatCharge) {
        //服务器停止了私聊收费
        return NO;
    }
    if (self.open_charge) {
        //不互粉  不订单  版本号比3.4.0 高
        if (!self.bothfollowing && !self.ordering && !self.chatUserVersionIsLow) {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (BOOL)isStrangerFirst {
    if (!self.globaChatCharge) {
        //服务器停止了私聊收费
        return NO;
    }
    
    // 版本过低权限提醒大约邀约
    if (self.chatUserVersionIsLow) {
        return NO;//版本过低的提示
    }
    // 邀约权限提醒大于  互粉
    if (self.ordering) {
        return YES;
    }
    
    // 互粉权限提醒大于其他
    if (self.bothfollowing && (self.open_charge || [ZZUserHelper shareInstance].loginer.open_charge)) {
        return YES;
    }
    
    if (self.bothfollowing) {
        return NO;
    }
    
    // 非互粉,非邀约,非版本过低  达人方开启私聊付费
    if (self.open_charge) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isChange {
    if (!self.globaChatCharge) {
        //服务器停止了私聊收费
        return NO;
    }
    
    //版本过低权限提醒大约邀约
    if (self.chatUserVersionIsLow) {
        return NO;//版本过低的提示
    }
    
    //邀约权限提醒大于  互粉
    if (self.ordering) {
        return YES;
    }
    
    //互粉权限提醒大于其他
    if (self.bothfollowing&&(self.open_charge||[ZZUserHelper shareInstance].loginer.open_charge)) {
        return YES;
    }
    if (self.bothfollowing) {
        return NO;
    }
  
    //非互粉,非邀约,非版本过低  任何一方开启私聊付费
    if (self.open_charge||[ZZUserHelper shareInstance].loginer.open_charge) {
        if ((!self.open_charge)&&[ZZUserHelper shareInstance].loginer.open_charge&&self.wait_answerCout<=0 &&self.isFirst)
        {
            return NO;//受益方第一次进入不显示
        }
        return YES;
        
    }
     return NO;
}
@end
