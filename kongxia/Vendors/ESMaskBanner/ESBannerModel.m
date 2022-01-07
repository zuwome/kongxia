//
//  ESBannerModel.m
//  zuwome
//
//  Created by MaoMinghui on 2018/9/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ESBannerModel.h"

@implementation ESBannerModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.bannerImage = dict[@"bannerImage"] ? dict[@"bannerImage"] : @"";
        self.backImage = dict[@"backImage"] ? dict[@"backImage"] : @"";
    }
    return self;
}

@end
