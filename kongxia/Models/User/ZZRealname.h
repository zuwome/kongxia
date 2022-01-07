//
//  ZZRealname.h
//  zuwome
//
//  Created by wlsy on 16/1/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZRequest.h"

@interface ZZRealnamePic : JSONModel
@property (strong, nonatomic) NSString *front;
@property (strong, nonatomic) NSString *hold;
@end
@interface ZZRealname : JSONModel

@property (strong, nonatomic) NSDate *updated_at;
@property (assign, nonatomic) NSInteger status;//0未认证，1待审核，2审核成功 3不通过
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) ZZRealnamePic *pic;

- (void)putParam:(NSDictionary *)param next:(requestCallback)next;

@end
