//
//  ZZChatKTVModel.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/16.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZChatKTVModel.h"

@implementation ZZChatKTVModel

+(instancetype)messageWithContent:(NSString *)content {
    ZZChatKTVModel *msg = [[ZZChatKTVModel alloc] init];
    if (msg) {
        msg.message = content;
    }
    return msg;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self){
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.message = [aDecoder decodeObjectForKey:@"message"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
        self.songUrl = [aDecoder decodeObjectForKey:@"songUrl"];
        self.songStatus = [aDecoder decodeObjectForKey:@"songStatus"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.message forKey:@"message"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
    [aCoder encodeObject:self.songUrl forKey:@"songUrl"];
    [aCoder encodeObject:self.songStatus forKey:@"songStatus"];
}

- (NSData *)encode {
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    
    if (self.extra) {
        [dataDict setObject:self.message forKey:@"message"];
    }
    
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    if (self.title) {
        [dataDict setObject:self.title forKey:@"title"];
    }
    if (self.content) {
        [dataDict setObject:self.content forKey:@"content"];
    }
    
    if (self.songUrl) {
        [dataDict setObject:self.songUrl forKey:@"songUrl"];
    }
    
    if (self.songStatus) {
        [dataDict setObject:self.songStatus forKey:@"songStatus"];
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

- (void)decodeWithData:(NSData *)data {
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
        self.songUrl = json[@"songUrl"];
        self.songStatus = json[@"songStatus"];
        
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

- (NSString *)conversationDigest {
    return self.content;
}

+ (NSString *)getObjectName {
    return @"song";
}

#if ! __has_feature(objc_arc)
-(void)dealloc {
    [super dealloc];
}
#endif//__has_feature(objc_arc)

@end
