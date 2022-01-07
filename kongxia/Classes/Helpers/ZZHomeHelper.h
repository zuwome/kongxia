//
//  ZZHomeHelper.h
//  zuwome
//
//  Created by angBiu on 16/7/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZRequest.h"
/**
 *  首页数据请求
 */
@interface ZZHomeHelper : NSObject
/**
 *  获取首页类别里面的列表数据(不需要登陆)
 *
 *  @param param 例子:cate:"near"
 *  @param next
 */
- (void)getHomeListWithParam:(NSDictionary *)param next:(requestCallback)next;

/**
 *  获取首页推荐列表的数据(未登陆)
 *
 *  @param param 例子:cate:"near"
 *  @param next
 */
- (void)fetchHomeListRecommendListWithoutLoginWithParam:(NSDictionary *)param next:(requestCallback)next;

/**
 *  获取首页需要登陆的列表数据 (需要登陆)
 *
 *  @param param 例子:cate:"near"
 *  @param next
 */
//- (void)getHomeListNeedLoginWithParam:(NSDictionary *)param next:(requestCallback)next;

@end
