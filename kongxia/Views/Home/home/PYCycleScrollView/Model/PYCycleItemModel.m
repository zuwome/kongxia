//
//  PYCycleItemModel.m
//  testOne
//
//  Created by 潘杨 on 2017/12/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import "PYCycleItemModel.h"

@implementation PYCycleItemModel
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}


-(PYCycleItemModelStyle)modelStyle {
    if ([_type isEqualToString:@"1"]) {
        return PYCycleItemModel_Image;
    }
    else{
        return PYCycleItemModel_title;

    }
}
@end
