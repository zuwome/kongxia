//
//  ZZMMDTipModel.h
//  zuwome
//
//  Created by angBiu on 16/8/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZMemedaModel.h"

@protocol ZZMMDTipListModel
@end

@interface ZZMMDTipListModel : JSONModel

@property (nonatomic, strong) NSString *sort_value1;
@property (nonatomic, strong) NSString *sort_value2;
@property (nonatomic, strong) ZZMMDTipsModel *tip;
@property (nonatomic, strong) NSString *created_at;

@end

/**
 *  贡献榜
 */
@interface ZZMMDTipModel : JSONModel

@property (nonatomic, assign) NSInteger my_tip_rank;//默认是0
@property (nonatomic, strong) ZZMMDTipsModel *my_tip;
@property (nonatomic, strong) NSMutableArray<ZZMMDTipListModel> *mmd_tips;
@property (nonatomic, strong) NSMutableArray<ZZMMDTipListModel> *sk_tips;

/**
 *  获取某个么么答的赏金榜
 *
 *  @param param sort_value1 和 sort_value2
 *  @param mid   么么答id
 *  @param next  回调
 */
+ (void)getMMDTipsListParam:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next;

+ (void)getSKTipsListParam:(NSDictionary *)param skId:(NSString *)skId next:(requestCallback)next;

+ (void)getMMDThreeTipsMid:(NSString *)mid next:(requestCallback)next;

+ (void)getSKThreeTipsSkId:(NSString *)skId next:(requestCallback)next;

@end
