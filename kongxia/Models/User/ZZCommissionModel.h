//
//  ZZCommissionModel.h
//  kongxia
//
//  Created by qiming xiao on 2019/10/12.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZCommissionInfoModel;

@interface ZZCommissionModel : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *inviteURL;

@property (nonatomic, strong) ZZCommissionInfoModel *tip;

@property (nonatomic, strong) ZZCommissionInfoModel *tip_b;

@end

@interface ZZCommissionInfoModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSArray<NSString *> *botttom_tip;

@property (nonatomic, copy) NSArray<NSString *> *img_title;

@property (nonatomic, copy) NSArray *arr;

@property (nonatomic, copy) NSArray *red_arr;

// 分享显示的文字
@property (nonatomic, copy) NSDictionary *url_text;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSDictionary *user;

@property (nonatomic, copy) NSArray *top_arr;

@property (nonatomic, copy) NSArray *top_arr_color;

@property (nonatomic, copy) NSArray *end_tip_arr;

@property (nonatomic, copy) NSArray *btn_arr;

@property (nonatomic, copy) NSDictionary *tixian_text;

@end

