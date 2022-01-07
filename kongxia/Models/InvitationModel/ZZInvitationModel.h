//
//  ZZInvitationModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZInvitationModel : JSONModel
@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *detailTitle;

@property(nonatomic,strong) NSArray *detailArray;

/**
是否是自己的原因  YES 是  No 达人的原因
 */
@property (nonatomic,assign,readonly) BOOL isResponsible;
@property (nonatomic, assign) double userPercent;//用户自己的原因最多退款
@property (nonatomic, assign) double daRenPercent;//达人的原因,最多退款
@end
