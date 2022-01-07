//
//  PYCycleItemModel.h
//  testOne
//
//  Created by 潘杨 on 2017/12/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
typedef enum : NSUInteger {
    PYCycleItemModel_Image = 0,            //纯图片
    PYCycleItemModel_title = 1,              //左侧图片右侧2行文字
}PYCycleItemModelStyle;

@interface PYCycleItemModel : JSONModel

/**
 cell的样式
 */
@property (nonatomic,assign,readonly)PYCycleItemModelStyle modelStyle;

/**
 标题
 */
@property (nonatomic,copy) NSString *title;

/**
 子标题
 */
@property (nonatomic,copy)NSString *sub_title;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *cover_url;

@property (nonatomic,copy)NSString *click_url;
@end
