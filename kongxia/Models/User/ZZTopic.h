//
//  ZZTopic.h
//  zuwome
//
//  Created by wlsy on 16/1/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZSkill.h"

@protocol ZZTopic
@end


@interface ZZTopic : JSONModel
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSMutableArray <ZZSkill> *skills;

- (NSString *)title;
@end
