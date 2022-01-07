//
//  ZZComment.h
//  zuwome
//
//  Created by wlsy on 16/1/31.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZRequest.h"

@interface ZZComment : JSONModel
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *order;
@property (nonatomic, strong) NSString *star;
@property (nonatomic, strong) NSMutableArray *content;
@property (nonatomic, strong) NSDate *created_at;

- (void)add:(NSString *)status next:(requestCallback)next;
@end
