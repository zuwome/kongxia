//
//  ZZKTVDetailsModel.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/15.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZKTVConfig.h"

typedef NS_ENUM(NSInteger, KTVTaskGiftReceiveStatus) {
    ReceiveStatusMine, //我获取了礼物
    ReceiveStatusEmpty, // 没有了
    ReceiveStatusPlenty,
};

@class ZZKTVReceiveUserModel;
@interface ZZKTVDetailsModel : NSObject

// 
@property (nonatomic, assign) double gift_rate;

@property (nonatomic, strong) ZZKTVModel *task;

// 是否被我领取 0: 没有 1: 有
@property (nonatomic, assign) NSInteger receiveStatus;

// 礼物是否被领取完毕
@property (nonatomic, assign) BOOL areGiftsAllCollected;

@property (nonatomic, strong) NSArray<ZZKTVReceiveUserModel *> *receiveList;

@property (nonatomic, assign) BOOL isPlaying;

@end

