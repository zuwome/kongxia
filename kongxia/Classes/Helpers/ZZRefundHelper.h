//
//  ZZRefundHelper.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZUploadBaseModel.h"
/**
  订单退款申请管理类
 */
@interface ZZRefundHelper : NSObject

/**
 证据信息界面
 当前区的row 的个数
 @param section 第几区

 @return
 */
+ (NSInteger)numberOfRowSectionWithSection:(NSInteger)section model:(ZZUploadBaseModel *)model;

/**
 返回每一个cell的title

 */
+ (NSString *)titleOfSectionWithIndexPath:(NSIndexPath *)indexPath  model:(ZZUploadBaseModel *)model;


/**
 返回当前的数据源
 */
+ (NSArray *)arrayOfSectionWithIndexPath:(NSIndexPath *)indexPath  model:(ZZUploadBaseModel *)model;

/**
 返回每个cell的identifier

 */
+ (NSString *)identifierWithIndexPath:(NSIndexPath *)indexPath  model:(ZZUploadBaseModel *)model;

@end
