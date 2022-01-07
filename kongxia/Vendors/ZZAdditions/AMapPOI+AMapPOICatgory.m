//
//  AMapPOI+AMapPOICatgory.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/24.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "AMapPOI+AMapPOICatgory.h"
#import <objc/runtime.h>

static void *strKey = &strKey;

@implementation AMapPOI (AMapPOICatgory)

-(void)setOriLocationUID:(NSString *)oriLocationUID {
    objc_setAssociatedObject(self, &strKey, oriLocationUID, OBJC_ASSOCIATION_COPY);
}

- (NSString *)oriLocationUID {
    return objc_getAssociatedObject(self, &strKey);
}


@end
