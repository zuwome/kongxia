//
//  ZZServiceChargeCell.h
//  zuwome
//
//  Created by YuTianLong on 2017/12/13.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZAuditFeeModel;

@interface ZZServiceChargeCell : UITableViewCell

@property (nonatomic, assign) BOOL selectCurrent;

+ (NSString *)reuseIdentifier;

- (void)setupWithModel:(ZZAuditFeeModel *)model;

@property (nonatomic, copy) void (^openBlock)(void);

@end
