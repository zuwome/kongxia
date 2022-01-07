//
//  ZZActivityUrlModel.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZActivityUrlModel.h"

@implementation ZZActivityUrlModel
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
- (NSDictionary<ZZActivityUrlModel> *)h5_activityDic {
    if (!_h5_activityDic) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (ZZActivityUrlModel *model in self.h5_activity) {
            [dic setObject:model forKey:model.viewControllerName[@"ios"]];
        }
        _h5_activityDic = [dic copy];
    }
    return _h5_activityDic;
}
@end
