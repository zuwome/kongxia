//
//  ZZTotalContributionHeadView.h
//  zuwome
//
//  Created by angBiu on 16/10/9.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZAttentView.h"
#import "ZZTotalContributionBgView.h"

#import "ZZTotalContributionModel.h"
#import "ZZMMDTipModel.h"

/**
 *  赏金贡献榜 ---- 头部view
 */
@interface ZZTotalContributionHeadView : UIView

@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) ZZTotalContributionBgView *firBgView;
@property (nonatomic, strong) ZZTotalContributionBgView *secBgView;
@property (nonatomic, strong) ZZTotalContributionBgView *thiBgView;
@property (nonatomic, strong) UILabel *firMoneyLabel;
@property (nonatomic, strong) UILabel *secMoneyLabel;
@property (nonatomic, strong) UILabel *thiMoneyLabel;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, copy) void(^touchHead)(NSString *uid);

- (void)setData:(NSMutableArray *)array model:(ZZTotalContributionModel *)model;
/**
 *  某个么么哒的贡献榜
 */
- (void)setMMDData:(NSMutableArray *)array model:(ZZMMDTipModel *)model;

@end
