//
//  ZZChatPacketModel.m
//  zuwome
//
//  Created by angBiu on 16/9/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatPacketModel.h"

@implementation ZZChatPacketModel

+(instancetype)messageWithContent:(NSString *)content
{
    ZZChatPacketModel *msg = [[ZZChatPacketModel alloc] init];
    if (msg) {
        msg.content = content;
    }
    
    return msg;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self){
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.mmd_id = [aDecoder decodeObjectForKey:@"mmd_id"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.mmd_id forKey:@"mmd_id"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
}

- (NSData *)encode
{
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    [dataDict setObject:self.content forKey:@"content"];
    [dataDict setObject:self.mmd_id forKey:@"mmd_id"];
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
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
        self.content = json[@"content"];
        self.mmd_id = json[@"mmd_id"];
        self.extra = json[@"extra"];
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
    return @"ZZChatPacketModel";
}

#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [super dealloc];
}
#endif//__has_feature(objc_arc)

@end
