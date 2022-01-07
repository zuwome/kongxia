//
//  ZZFindModel.h
//  zuwome
//
//  Created by angBiu on 16/8/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZFindFashionModel : JSONModel

@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, strong) NSString *sort_value;
@property (nonatomic, strong) NSString *sort_value1;
@property (nonatomic, strong) NSString *sort_value2;

/**
 *  发现－红人
 *
 *  @param param 分页： sort_value
 *  @param next  回调
 */
- (void)getFindFashionList:(NSDictionary *)param next:(requestCallback)next;

/**
 *  发现－红人(需要登录)
 *
 *  @param param 分页： sort_value
 *  @param next  回调
 */
- (void)getFindFashionListNeedLogin:(NSDictionary *)param next:(requestCallback)next;

@end

@interface ZZFindModel : JSONModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *__v;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *share_img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *sub_title;

/**
 *  发现－banner
 *
 *  @param next 回调
 */
- (void)getFindBanner:(requestCallback)next;

@end
