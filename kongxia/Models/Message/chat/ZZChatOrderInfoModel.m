//
//  ZZChatOrderInfoModel.m
//  zuwome
//
//  Created by angBiu on 16/10/20.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatOrderInfoModel.h"

@implementation ZZChatOrderInfoModel

+(instancetype)messageWithContent:(NSString *)content
{
    ZZChatOrderInfoModel *msg = [[ZZChatOrderInfoModel alloc] init];
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
        self.order_id = [aDecoder decodeObjectForKey:@"order_id"];
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
    [aCoder encodeObject:self.order_id forKey:@"order_id"];
}

- (NSData *)encode
{
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    [dataDict setObject:self.content forKey:@"content"];
    [dataDict setObject:self.order_id forKey:@"order_id"];
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
        self.order_id = json[@"order_id"];
        self.typeContent = json[@"typeContent"];
       
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
    return @"Message_Order";
}

#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [super dealloc];
}
#endif//__has_feature(objc_arc)


@end
