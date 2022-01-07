//
//  ZZTotalContributionBottomView.h
//  zuwome
//
//  Created by angBiu on 2016/10/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZMemedaModel.h"

@interface ZZTotalContributionBottomView : UIView

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UILabel *moneyLabel;

- (void)setData:(ZZMMDTipsModel *)model myRank:(NSInteger)rank;

@end
