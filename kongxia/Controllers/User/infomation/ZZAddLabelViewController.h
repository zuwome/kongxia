//
//  ZZAddLabelViewController.h
//  zuwome
//
//  Created by angBiu on 16/6/21.
//  Copyright © 2016年 zz. All rights reserved.
//

typedef NS_ENUM(NSInteger,RentLabelType) {
    RentLabelTypeInterest,
    RentLabelTypeJob
};
#import "ZZViewController.h"
@class ZZUser;
/**
 *  添加兴趣 等的标签
 */
@interface ZZAddLabelViewController : ZZViewController

@property (nonatomic, copy) dispatch_block_t updateLabel;
@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, assign) RentLabelType type;
@property (nonatomic, assign) NSInteger maxCount;

@end
