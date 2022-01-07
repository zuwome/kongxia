//
//  ZZGiftModel.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/22.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZGiftModel : NSObject

@property (nonatomic,   copy) NSString  *_id;
    
@property (nonatomic,   copy) NSString  *name;

@property (nonatomic,   copy) NSString  *icon;

@property (nonatomic, assign) NSInteger mcoin;

@property (nonatomic,   copy) NSString  *info;

@property (nonatomic, assign) double    price;

@property (nonatomic,   copy) NSString  *from_msg_a;

@property (nonatomic,   copy) NSString  *from_msg_b;

@property (nonatomic,   copy) NSString  *to_msg_a;

@property (nonatomic,   copy) NSString  *to_msg_b;

@property (nonatomic,   copy) NSNumber  *charm_num;

@property (nonatomic, copy) NSString *color;

// 动画
@property (nonatomic, copy) NSString *lottie;

@end

