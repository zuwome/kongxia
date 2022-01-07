//
//  ZZWeiChatEvaluationNetwork.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//微信号评价的接口

#import <Foundation/Foundation.h>
#import "ZZRequest.h"
@interface ZZWeiChatEvaluationNetwork : NSObject


/**
  微信号评价

 @param uid 被评价人的uid
 @param score 评价的类型 score:1//1差评  5好评
 @param content  评价的内容 例如content:"不真实|不回信息|假的"，//用竖线分隔。没有评价内容，字段不要传。
 @param nextCallback 评价完成的回调
 */
+(void)weiChatEvaluationWithEvaluationUid:(NSString *)uid
                                    score:(NSInteger)score
                                  content:(NSString *)content
                                     next:(requestCallback)nextCallback ;

/**
 举报虚假微信号

 @param weiXinNumber 微信号
 @param userId 被举报人的uid
 */
+ (void)reportFalseWXWithWeiXinNumber:(NSString *)weiXinNumber  userId:(NSString *)userId ;

/**
 查看是否举报过
*/
+ (void)checkIfisReported:(NSString *)userId next:(requestCallback)nextCallback;

@end

