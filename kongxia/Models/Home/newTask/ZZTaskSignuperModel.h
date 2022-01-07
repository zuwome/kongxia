//
//  ZZTaskSignuperModel.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/22.
//  Copyright © 2019 TimoreYu. All rights reserved.
//
#import <JSONModel/JSONModel.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZTaskSignuperModel : JSONModel

@property (nonatomic, copy) NSString *_id;

@property (nonatomic, copy) NSString *pd_agreement_at;

@property (nonatomic, copy) NSString *pd_owner;

@property (nonatomic, copy) NSString *selected_at;

@property (nonatomic, strong) ZZUser *user;

@property (nonatomic, copy) NSString *pd;

@property (nonatomic, assign) NSInteger __v;

@property (nonatomic, assign) NSInteger push_type;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger pd_type;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, copy) NSString *pd_km;

@end

NS_ASSUME_NONNULL_END
