//
//  ZZUserWXModel.h
//  zuwome
//
//  Created by angBiu on 2017/6/2.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZUserWXModel : JSONModel

@property (nonatomic, strong) NSString *wid;
@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, strong) NSString *wechat_no;
@property (nonatomic, strong) NSString *sort_value;

+ (void)getUserWxList:(NSDictionary *)param next:(requestCallback)next;

+ (void)deleteWXRecord:(NSString *)wid next:(requestCallback)next;

@end
