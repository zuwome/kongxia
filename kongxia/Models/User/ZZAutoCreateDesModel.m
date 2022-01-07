//
//  ZZAutoCreateDesModel.m
//  zuwome
//
//  Created by qiming xiao on 2019/5/9.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZAutoCreateDesModel.h"

@implementation ZZAutoCreateDesModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"dimension" : [ZZAutoCreateDimensionModel class],
             @"templateLists": [ZZAutoCreatetemplateModel class],
             };
}

/**
 *  换名字
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"templateLists"        : @"template",
             };
}

- (BOOL)didHaveSkills {
    __block BOOL didHave = NO;
    [_dimension enumerateObjectsUsingBlock:^(ZZAutoCreateDimensionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == 3) {
            didHave = YES;
            *stop = YES;
        }
    }];
    
    return didHave;
}
@end

@implementation ZZAutoCreateDimensionModel


@end

@implementation ZZAutoCreatetemplateModel



@end
