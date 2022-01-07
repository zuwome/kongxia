//
//  ZZCommissionIncomModel.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/29.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZZCommissionIncomModel : NSObject

@property (nonatomic, copy) NSString *_id;

@property (nonatomic, assign) double agency_price;

@property (nonatomic, assign) double price;

@property (nonatomic, assign) NSInteger rate;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, copy) NSString *created_at_desc;

@property (nonatomic, copy) NSString *from;

@property (nonatomic, strong) ZZUser *to;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *wechat_seen;
@end

