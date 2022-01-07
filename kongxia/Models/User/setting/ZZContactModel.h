//
//  ZZContactModel.h
//  zuwome
//
//  Created by angBiu on 2016/10/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  联系人 ----- model
 */
@interface ZZContactModel : NSObject

@property (nonatomic, strong) NSString *givenName;
@property (nonatomic, strong) NSString *familyName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSArray *phoneArray;

/**
 *  屏蔽通讯录
 *
 *  @param param contacts://字符串 如"1233938348,1307485758,73647449"
 *  @param next  <#next description#>
 */
- (void)blcokContact:(NSDictionary *)param next:(requestCallback)next;
/**
 *  取消屏蔽通讯录
 *
 *  @param param contacts://字符串 如"1233938348,1307485758,73647449"
 *  @param next  <#next description#>
 */
- (void)unblockContact:(NSDictionary *)param next:(requestCallback)next;
/**
 *  获取屏蔽列表
 *
 *  @param next <#next description#>
 */
- (void)getContactBlockList:(requestCallback)next;

@end
