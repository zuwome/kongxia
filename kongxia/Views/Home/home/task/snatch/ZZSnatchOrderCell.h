//
//  ZZSnatchOrderCell.h
//  zuwome
//
//  Created by angBiu on 2017/7/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZColorCycleView.h"
#import "ZZOrderCountDownView.h"

#import "ZZSnatchReceiveModel.h"

static NSString *OrderTimeCountNotification = @"OrderTimeCountNotification";

@interface ZZSnatchOrderCell : UITableViewCell

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ZZSexImgView *sexImgView;
@property (nonatomic, strong) UIImageView *identifierImgView;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) ZZColorCycleView *cycleView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *snatchBtn;

@property (nonatomic, strong) UILabel *endLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) ZZOrderCountDownView *countDownView;
@property (nonatomic, strong) ZZSnatchReceiveModel *model;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) dispatch_block_t touchSnatch;

- (void)setData:(ZZSnatchReceiveModel *)model;

@end
