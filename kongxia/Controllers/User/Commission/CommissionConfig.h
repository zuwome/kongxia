//
//  CommissionConfig.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/2.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#ifndef CommissionConfig_h
#define CommissionConfig_h
typedef NS_ENUM(NSInteger, CommissionDetailsType) {
    CommissionIncome,
    CommissionDetails,
    CommissionInvited,
};

typedef NS_ENUM(NSInteger, CommissionChannel) {
    CommissionChannelMoments = 0,
    CommissionChannelWechat,
    CommissionChannelQQ,
    CommissionChannelWeibo,
    
    CommissionChannelSnapShot = 98,
    CommissionChannelLink = 99,

};

typedef NS_ENUM(NSInteger, CommissionChannelEntry) {
    CommissionChannelEntryMyCommission,
    CommissionChannelEntryUser,
};

#define PageMenuH 50

#define NaviH 64

#define HeaderViewH 155

#define insert (isIPhoneX ? (84 + 34 + PageMenuH) : 0)


#endif /* CommissionConfig_h */
