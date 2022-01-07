//
//  ZZMessageChatWechatPayModel.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZMessageChatWechatPayModel.h"

@implementation ZZMessageChatWechatPayModel


+(instancetype)messageWithContent:(NSString *)content
{
    ZZMessageChatWechatPayModel *msg = [[ZZMessageChatWechatPayModel alloc] init];
    if (msg) {
        msg.content = content;
    }
    
    return msg;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self){
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
        self.pay_type = [aDecoder decodeObjectForKey:@"pay_type"];
        self.typeContent = [aDecoder decodeObjectForKey:@"typeContent"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.typeContent forKey:@"typeContent"];
   
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
    [aCoder encodeObject:self.pay_type forKey:@"pay_type"];
}

- (NSData *)encode
{
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    [dataDict setObject:self.content forKey:@"content"];
    [dataDict setObject:self.pay_type forKey:@"pay_type"];
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    if (self.title) {
        [dataDict setObject:self.title forKey:@"title"];
    }
    
    if (self.typeContent) {
        [dataDict setObject:self.typeContent forKey:@"typeContent"];
        
    }
    
    
    if (self.senderUserInfo) {
        NSMutableDictionary *__dic=[[NSMutableDictionary alloc]init];
        if (self.senderUserInfo.name) {
            [__dic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [__dic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [__dic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:__dic forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

- (void)decodeWithData:(NSData *)data
{
    __autoreleasing NSError* __error = nil;
    if (!data) {
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&__error];
    
    if (json) {
        self.title = json[@"title"];
        self.content = json[@"content"];
        self.extra = json[@"extra"];
        self.pay_type = json[@"pay_type"];
        self.typeContent = json[@"typeContent"];
        self.wechatseenId = json[@"wechatseenId"];
        
        NSObject *__object = [json objectForKey:@"user"];
        NSDictionary *userinfoDic = nil;
        if (__object &&[__object isMemberOfClass:[NSDictionary class]]) {
            userinfoDic = (NSDictionary *)__object;
        }
        if (userinfoDic) {
            RCUserInfo *userinfo =[RCUserInfo new];
            userinfo.userId = [userinfoDic objectForKey:@"id"];
            userinfo.name =[userinfoDic objectForKey:@"name"];
            userinfo.portraitUri =[userinfoDic objectForKey:@"icon"];
            self.senderUserInfo = userinfo;
        }
    }
}
- (NSString *)conversationDigest
{
      return self.content;
}

+(NSString *)getObjectName
{
    return @"Wechat_Pay";
}

#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [super dealloc];
}
#endif//__has_feature(objc_arc)



@end
