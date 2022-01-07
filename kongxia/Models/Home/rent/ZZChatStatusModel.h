//
//  ZZChatStatusModel.h
//  zuwome
//
//  Created by angBiu on 16/8/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZChatStatusModel : JSONModel

@property (nonatomic, assign) NSInteger chat_status;//0不可以聊天  1可以聊天
@property (nonatomic, strong) NSString *msg;//不可以聊天时弹出窗口的文字
@property (nonatomic, assign) NSInteger private_hb_status;//1有私人红包   0没有
@property (nonatomic, assign) NSInteger can_disappear_after_reading;//1可以和对方阅后即焚  0不可以
@property (nonatomic, strong) NSString *disappear_after_reading_error_msg;//錯误提示文案
@property (nonatomic, assign) NSInteger disappear_after_reading_error_type;//1版本过低 2未关注

/**
 *  获取聊天状态
 *
 *  @param uid  uid
 *  @param next 回调
 */
+ (void)getChatStatus:(NSString *)uid next:(requestCallback)next;

@end
