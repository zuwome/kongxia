//
//  ZZUserInfoModel.h
//  zuwome
//
//  Created by angBiu on 2016/11/4.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZUserInfoModel : JSONModel

@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, strong) NSString *order_status_text;

@property (nonatomic, strong) NSString *uid;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic,   copy) NSString *city;

@property (nonatomic,   copy) NSArray  *loc;

@property (nonatomic, assign) long latestMessageID;

@property (nonatomic, assign) BOOL didHaveGift;

@property (nonatomic,   copy) NSArray  *animationsArr;

// 有礼物的用户
@property (nonatomic,   copy) NSArray  *animationUsersArr;

@end
