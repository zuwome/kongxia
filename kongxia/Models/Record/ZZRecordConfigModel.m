//
//  ZZRecordConfigModel.m
//  zuwome
//
//  Created by angBiu on 2017/2/20.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRecordConfigModel.h"

@implementation ZZRecordConfigModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.filterIndex = [[aDecoder decodeObjectForKey:@"filterIndex"] integerValue];
        self.beautyIndex = [[aDecoder decodeObjectForKey:@"beautyIndex"] integerValue];
        self.faceIndex = [[aDecoder decodeObjectForKey:@"faceIndex"] integerValue];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInteger:self.filterIndex] forKey:@"filterIndex"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.beautyIndex] forKey:@"beautyIndex"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.faceIndex] forKey:@"faceIndex"];
}

@end
