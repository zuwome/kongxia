//
//  ZZMessage.h
//  zuwome
//
//  Created by wlsy on 16/1/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZRequest.h"

@class ZZMessage;
@interface ZZMessageResponseModel: JSONModel

@property (nonatomic, copy) NSString *price_text;

@property (nonatomic, copy) NSArray<ZZMessage *> *results;

@end

@interface ZZMessage : JSONModel
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *order;
@property (strong, nonatomic) NSString *to;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *created_at;


- (NSString *)dateString;

+ (void)pullRent:(requestCallback)next;
+ (void)pullRealname:(requestCallback)next;
+ (void)pullOrder:(NSString *)orderId next:(requestCallback)next;

@end
