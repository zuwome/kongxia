//
//  ZZGifMessageModel.m
//  zuwome
//
//  Created by 潘杨 on 2018/4/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

//
//  ZZVideoMessageCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/8.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZGifMessageModel.h"

@implementation ZZGifMessageModel

+(RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

#pragma mark – NSCoding protocol methods
#define KEY_TXTMSG_MessageDigest @"messageDigest"
#define KEY_TXTMSG_EXTRA @"extra"
#define KEY_TXTMSG_Type @"type"
#define KEY_TXTMSG_resultsType @"resultsType"
#define KEY_TXTMSG_localPath @"localPath"
#define KEY_TXTMSG_fileUrl @"fileUrl"

#define KEY_TXTMSG_gifHeight @"gifHeight"
#define KEY_TXTMSG_gifWidth @"gifWidth"
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.messageDigest = [aDecoder decodeObjectForKey:KEY_TXTMSG_MessageDigest];
        self.extra = [aDecoder decodeObjectForKey:KEY_TXTMSG_EXTRA];
        self.type = [aDecoder decodeObjectForKey:KEY_TXTMSG_Type];
        self.resultsType = [aDecoder decodeIntForKey:KEY_TXTMSG_resultsType];
        self.localPath = [aDecoder decodeObjectForKey:KEY_TXTMSG_localPath];
        self.fileUrl = [aDecoder decodeObjectForKey:KEY_TXTMSG_fileUrl];
        self.gifWidth = [aDecoder decodeIntForKey:KEY_TXTMSG_gifWidth];
        self.gifHeight = [aDecoder decodeIntForKey:KEY_TXTMSG_gifHeight];

    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.resultsType forKey:KEY_TXTMSG_resultsType];
    [aCoder encodeInteger:self.gifHeight forKey:KEY_TXTMSG_gifHeight];
    [aCoder encodeInteger:self.gifWidth forKey:KEY_TXTMSG_gifWidth];
    [aCoder encodeObject:self.messageDigest forKey:KEY_TXTMSG_MessageDigest];
    [aCoder encodeObject:self.extra forKey:KEY_TXTMSG_EXTRA];
    [aCoder encodeObject:self.type forKey:KEY_TXTMSG_Type];
    [aCoder encodeObject:self.localPath forKey:KEY_TXTMSG_localPath];
    [aCoder encodeObject:self.fileUrl forKey:KEY_TXTMSG_fileUrl];
    
}
#pragma mark – RCMessageCoding delegate methods

-(NSData *)encode {
    
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    if (self.extra) {
        [dataDict setObject:self.extra forKey:KEY_TXTMSG_EXTRA];
    }
    if (self.messageDigest) {
        [dataDict setObject:self.messageDigest forKey:KEY_TXTMSG_MessageDigest];
    }
    if (self.type) {
        [dataDict setObject:self.type forKey:KEY_TXTMSG_Type];
    }
    if (self.resultsType) {
        [dataDict setObject:@(self.resultsType) forKey:KEY_TXTMSG_resultsType];
    }
    if (self.localPath) {
        [dataDict setObject:self.localPath forKey:KEY_TXTMSG_localPath];
    }
    if (self.fileUrl) {
        [dataDict setObject:self.fileUrl forKey:KEY_TXTMSG_fileUrl];
    }
    [dataDict setObject:@(self.gifWidth) forKey:KEY_TXTMSG_gifWidth];
    [dataDict setObject:@(self.gifHeight) forKey:KEY_TXTMSG_gifHeight];

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
        self.messageDigest = json[@"messageDigest"];
        self.extra = json[@"extra"];
        NSString *string = json[KEY_TXTMSG_resultsType] ;
        
        self.resultsType = [string integerValue];
        self.fileUrl = json[KEY_TXTMSG_fileUrl];
        self.localPath = json[KEY_TXTMSG_localPath];
        self.type = json[KEY_TXTMSG_Type];
        self.gifWidth = [json[KEY_TXTMSG_gifWidth] integerValue];
        self.gifHeight = [json[KEY_TXTMSG_gifHeight] integerValue];

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
    return @"[动画表情]";
}
+(NSString *)getObjectName {
    return @"ZZGifMessage";
}
#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [super dealloc];
}
#endif//__has_feature(objc_arc)
@end


