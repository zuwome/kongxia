//
//  ZZCommissionInviteUserModel.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/9.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZCommissionInviteUserInfoModel;

@interface ZZCommissionInviteUserModel : NSObject

// 用户数据
@property (nonatomic, copy) NSArray<ZZCommissionInviteUserInfoModel *> *allUserList;

@end


@interface ZZCommissionInviteUserInfoModel : NSObject

@property (nonatomic, strong) ZZUser *to;

@end
