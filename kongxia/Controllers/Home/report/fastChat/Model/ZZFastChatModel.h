//
//  ZZFastChatModel.h
//  zuwome
//
//  Created by YuTianLong on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZFastChatModel : JSONModel

@property (nonatomic, copy) NSString *sort_value;
@property (nonatomic, copy) NSString *current_type;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, strong) ZZUser *user;

@end
