//
//  ZZTotalContributionCell.h
//  zuwome
//
//  Created by angBiu on 16/10/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZAttentView.h"
#import "ZZTotalContributionModel.h"
#import "ZZMMDTipModel.h"
/**
 *  贡献总榜 cell
 */
@interface ZZTotalContributionCell : UITableViewCell

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) ZZAttentView *attentView;
@property (nonatomic, strong) UIView *lineView;

/**
 *  贡献总榜
 *
 *  @param model     <#model description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)setData:(ZZTotalTipListModel *)model indexPath:(NSIndexPath *)indexPath;
/**
 *  某个么么哒的贡献总榜
 *
 *  @param mode      <#mode description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)setMMDData:(ZZMMDTipListModel *)model indexPath:(NSIndexPath *)indexPath;

@end
