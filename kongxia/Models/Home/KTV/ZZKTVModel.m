//
//  ZZKTVModel.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVModel.h"

@implementation ZZKTVModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"giftModel" : [ZZGiftModel class],
             @"from" : [ZZUser class],
             @"song_list" : [ZZKTVSongModel class],
             };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _is_anonymous = 1;
        _gift_count = 2;
        if ([ZZUserHelper shareInstance].loginer.gender == 1) {
            _gender = 2;
        }
        else if ([ZZUserHelper shareInstance].loginer.gender == 2) {
            _gender = 1;
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.gender = [[aDecoder decodeObjectForKey:@"gender"] boolValue];
        self.gift_count = [[aDecoder decodeObjectForKey:@"gift_count"] intValue];
        self.is_anonymous = [[aDecoder decodeObjectForKey:@"is_anonymous"] intValue];
        self.savedGiftID = [aDecoder decodeObjectForKey:@"savedGiftID"];
        self.savedGiftName = [aDecoder decodeObjectForKey:@"savedGiftName"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.gender] forKey:@"gender"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.gift_count] forKey:@"gift_count"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.is_anonymous] forKey:@"is_anonymous"];
    [aCoder encodeObject:self.savedGiftID forKey:@"is_anonymous"];
    [aCoder encodeObject:self.savedGiftName forKey:@"savedGiftName"];
}



@end
