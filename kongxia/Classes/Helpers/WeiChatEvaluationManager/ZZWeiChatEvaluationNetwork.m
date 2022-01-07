//
//  ZZWeiChatEvaluationNetwork.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//微信号评价的接口

#import "ZZWeiChatEvaluationNetwork.h"
#import "ZZReportModel.h"
@implementation ZZWeiChatEvaluationNetwork
/**
 微信号评价
 
 @param uid 被评价人的uid
 @param params 评价的字典
 例如 content:"不真实|不回信息|假的"，//用竖线分隔。没有评价内容，字段不要传。
 score:1//1差评  5好评
 @param nextCallback 回调
 */
+(void)weiChatEvaluationWithEvaluationUid:(NSString *)uid
                                     score:(NSInteger)score
                                  content:(NSString *)content
                                     next:(requestCallback)nextCallback  {
    NSMutableDictionary *evaluation = [NSMutableDictionary dictionary];
    switch (score-300) {
        case 1:
            //差评
            [evaluation setObject:@1 forKey:@"score"];

            break;
        case 5:
            //好评
            [evaluation setObject:@5 forKey:@"score"];

            break;
        default:
            return;
            break;
    }
    if (!isNullString(content)) {
        [evaluation setObject:content forKey:@"content"];
    }
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/wechat/comment",uid] params:evaluation next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (nextCallback) {
            nextCallback(error,data,task);
        }
    }];
}
//举报虚假微信
+ (void)reportFalseWXWithWeiXinNumber:(NSString *)weiXinNumber  userId:(NSString *)userId {
    if (!weiXinNumber) {    //预防不存在微信号时发生崩溃
        return ;
    }
    [ZZReportModel reportWithParam:@{@"content":weiXinNumber,
                                     @"type":@"1"} uid:userId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                                         if (error) {
                                             [ZZHUD showErrorWithStatus:error.message];
                                         } else {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [ZZHUD showSuccessWithStatus:@"谢谢您的举报，我们将在2个工作日内解决!"];
                                             });
                                         }
                                     }];
}

/**
 查看是否举报过
*/
+ (void)checkIfisReported:(NSString *)userId next:(requestCallback)nextCallback {
    
    NSDictionary *param = @{
        @"from" : [ZZUserHelper shareInstance].loginer.uid,
        @"to" : userId
    };
    [ZZHUD show];
    [ZZRequest method:@"POST"
                 path:@"/api/wechat/existReportWechat"
               params:param
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [ZZHUD dismiss];
        if (nextCallback) {
            nextCallback(error,data,task);
        }
    }];
}

@end
