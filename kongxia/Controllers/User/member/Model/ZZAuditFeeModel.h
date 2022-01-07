//
//  ZZAuditFeeModel.h
//  zuwome
//
//  Created by YuTianLong on 2017/12/13.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZAuditFeeModel : JSONModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *duration;//月数
@property (nonatomic, copy) NSString *price;//价格
@property (nonatomic, copy) NSString *discount;//折扣

@property (nonatomic, copy) NSString *duration_text;//月数，显示的文案
@property (nonatomic, copy) NSString *price_text;//价格，显示的文案
@property (nonatomic, copy) NSString *discount_text;//折扣，显示的文案

@end
