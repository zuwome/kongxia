//
//  ZZChatGiftModel.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZChatGiftModel.h"

@implementation ZZChatGiftModel

+(instancetype)messageWithContent:(NSString *)content {
    ZZChatGiftModel *msg = [[ZZChatGiftModel alloc] init];
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
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.from_msg_a = [aDecoder decodeObjectForKey:@"from_msg_a"];
        self.from_msg_b = [aDecoder decodeObjectForKey:@"from_msg_b"];
        self.to_msg_a = [aDecoder decodeObjectForKey:@"to_msg_a"];
        self.to_msg_b = [aDecoder decodeObjectForKey:@"to_msg_b"];
        self.charm_num = [aDecoder decodeObjectForKey:@"charm_num"];
        self.color = [aDecoder decodeObjectForKey:@"color"];
        self.lottie = [aDecoder decodeObjectForKey:@"lottie"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.message forKey:@"message"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.from_msg_a forKey:@"from_msg_a"];
    [aCoder encodeObject:self.from_msg_b forKey:@"from_msg_b"];
    [aCoder encodeObject:self.to_msg_a forKey:@"to_msg_a"];
    [aCoder encodeObject:self.to_msg_b forKey:@"to_msg_b"];
    [aCoder encodeObject:self.charm_num forKey:@"charm_num"];
    [aCoder encodeObject:self.color forKey:@"color"];
    [aCoder encodeObject:self.lottie forKey:@"lottie"];
}

- (NSData *)encode {
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
    if (self.icon) {
        [dataDict setObject:self.icon forKey:@"icon"];
    }
    if (self.from_msg_a) {
        [dataDict setObject:self.from_msg_a forKey:@"from_msg_a"];
    }
    if (self.from_msg_b) {
        [dataDict setObject:self.from_msg_b forKey:@"from_msg_b"];
    }
    if (self.to_msg_a) {
        [dataDict setObject:self.to_msg_a forKey:@"to_msg_a"];
    }
    if (self.to_msg_b) {
        [dataDict setObject:self.to_msg_b forKey:@"to_msg_b"];
    }
    if (self.charm_num) {
        [dataDict setObject:self.charm_num forKey:@"charm_num"];
    }
    if (self.charm_num) {
        [dataDict setObject:self.color forKey:@"color"];
    }
    if (self.lottie) {
        [dataDict setObject:self.lottie forKey:@"lottie"];
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
        self.icon = json[@"icon"];
        self.from_msg_a = json[@"from_msg_a"];
        self.from_msg_b = json[@"from_msg_b"];
        self.to_msg_a = json[@"to_msg_a"];
        self.to_msg_b = json[@"to_msg_b"];
        self.charm_num = json[@"charm_num"];
        self.color = json[@"color"];
        self.lottie = json[@"lottie"];
        
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
    return @"ZZChatGift";
}

#if ! __has_feature(objc_arc)
-(void)dealloc {
    [super dealloc];
}
#endif//__has_feature(objc_arc)


@end
