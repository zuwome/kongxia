//
//  ZZNotificationModel.h
//  zuwome
//
//  Created by angBiu on 16/8/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZNotificationModel : JSONModel

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *message_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *mmd_id;
@property (nonatomic, strong) NSString *sk_id;
@property (nonatomic, strong) NSString *order;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *btnTitle;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *from_user;

@end
