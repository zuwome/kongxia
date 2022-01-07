//
//  ZZTotalContributionModel.h
//  zuwome
//
//  Created by angBiu on 2016/10/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ZZMemedaModel.h"

@protocol ZZTotalTipListModel
@end

@interface ZZTotalTipListModel : JSONModel

@property (nonatomic, strong) NSString *sort_value1;
@property (nonatomic, strong) NSString *sort_value2;
@property (nonatomic, strong) ZZMMDTipsModel *tip_total;
@property (nonatomic, strong) NSString *created_at;

@end


@interface ZZTotalContributionModel : JSONModel

@property (nonatomic, strong) NSNumber *get_hb_price_total;
@property (nonatomic, strong) ZZMMDTipsModel *my_tip_total;
@property (nonatomic, assign) NSInteger my_tip_total_rank;
@property (nonatomic, strong) NSMutableArray<ZZTotalTipListModel> *tip_totals;

/**
 *  获取某个人的赏金贡献总榜
 *
 *  @param uid  uid
 *  @param next next
 */
- (void)getContributionListWithParam:(NSDictionary *)param  uid:(NSString *)uid next:(requestCallback)next;

@end
