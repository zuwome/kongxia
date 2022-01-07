//
//  ZZChatSelectionModel.m
//  zuwome
//
//  Created by angBiu on 2017/7/27.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZChatSelectionModel.h"

@implementation ZZChatSelectionModel

+(instancetype)messageWithContent:(NSString *)content
{
    ZZChatSelectionModel *msg = [[ZZChatSelectionModel alloc] init];
    if (msg) {
        msg.message = content;
    }
    
    return msg;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self){
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.message = [aDecoder decodeObjectForKey:@"message"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
        self.type = [[aDecoder decodeObjectForKey:@"type"] integerValue];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.message forKey:@"message"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
}

- (NSData *)encode
{
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    [dataDict setObject:self.message forKey:@"message"];
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    if (self.title) {
        [dataDict setObject:self.title forKey:@"title"];
    }
    if (self.content) {
        [dataDict setObject:self.content forKey:@"content"];
    }
    if (self.type) {
        [dataDict setObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
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
        self.message = json[@"message"];
        self.content = json[@"content"];
        self.extra = json[@"extra"];
        self.type = [json[@"type"] integerValue];
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
    return @"Message_Selections";
}

#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [super dealloc];
}
#endif//__has_feature(objc_arc)

@end
