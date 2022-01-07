//
//  ZZTransfer.h
//  zuwome
//
//  Created by wlsy on 16/2/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZRequest.h"

@interface ZZTransfer : JSONModel
@property (strong, nonatomic) NSString *recipient;
@property (strong, nonatomic) NSString *channel;
@property (strong, nonatomic) NSNumber *amount;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *created_at_text;
@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *__v;
@property (strong, nonatomic) NSString *zfbName;
@property (strong, nonatomic) NSString *zfbAccount;
//@property (strong, nonatomic) NSString *status_text;
//@property (nonatomic, strong) NSString *pic;

@property (nonatomic, assign) NSInteger face_status;

- (void)add:(requestCallback)next;

- (void)rechargeWithParam:(NSDictionary *)param next:(requestCallback)next;

@end
