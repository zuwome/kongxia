//
//  ZZVideoMessageCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/8.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZVideoMessage.h"

@implementation ZZVideoMessage
+(instancetype)messageWithContent:(NSString *)content {
    ZZVideoMessage *msg = [[ZZVideoMessage alloc] init];
    if (msg) {
        msg.content = content;
    }
    return msg;
}
+(RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

#pragma mark – NSCoding protocol methods
#define KEY_TXTMSG_CONTENT @"content"
#define KEY_TXTMSG_EXTRA @"extra"
#define KEY_TXTMSG_videoType @"videoType"

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:KEY_TXTMSG_CONTENT];
        self.extra = [aDecoder decodeObjectForKey:KEY_TXTMSG_EXTRA];
        self.videoType = [aDecoder decodeObjectForKey:KEY_TXTMSG_videoType];

    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.content forKey:KEY_TXTMSG_CONTENT];
    [aCoder encodeObject:self.extra forKey:KEY_TXTMSG_EXTRA];
    [aCoder encodeObject:self.videoType forKey:KEY_TXTMSG_videoType];

}
#pragma mark – RCMessageCoding delegate methods

-(NSData *)encode {
    
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    [dataDict setObject:self.content forKey:KEY_TXTMSG_CONTENT];
    if (self.extra) {
        [dataDict setObject:self.extra forKey:KEY_TXTMSG_EXTRA];
    }
    if (self.videoType) {
        [dataDict setObject:self.videoType forKey:KEY_TXTMSG_videoType];
    }
    if (self.senderUserInfo) {
        NSMutableDictionary *videoDic=[[NSMutableDictionary alloc]init];
        if (self.senderUserInfo.name) {
            [videoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [videoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [videoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:videoDic forKey:@"user"];
    }
    
    //NSDictionary* dataDict = [NSDictionary dictionaryWithObjectsAndKeys:self.content, @"content", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

-(void)decodeWithData:(NSData *)data {
    __autoreleasing NSError* __error = nil;
    if (!data) {
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&__error];
    if (json) {
        self.content = json[@"content"];
        self.extra = json[@"extra"];
        self.videoType = json[KEY_TXTMSG_videoType];
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
//- (NSString *)showContent {
//
//
//}

- (NSString *)conversationDigest
{
    return @"[视屏聊天]";
}
+(NSString *)getObjectName {
    return @"ZZVideoMessage";
}
#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [super dealloc];
}
#endif//__has_feature(objc_arc)

@end

