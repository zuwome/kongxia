//
//  ZZSnatchListCell.h
//  zuwome
//
//  Created by angBiu on 2017/8/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZColorCycleView.h"
#import "ZZOrderCountDownView.h"

#import "ZZSnatchReceiveModel.h"

@interface ZZSnatchListCell : UITableViewCell

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ZZSexImgView *sexImgView;
@property (nonatomic, strong) UIImageView *identifierImgView;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) ZZColorCycleView *cycleView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *snatchBtn;

@property (nonatomic, strong) UILabel *endLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) ZZOrderCountDownView *countDownView;

//@property (nonatomic, strong) UIImageView *typeImgView;
@property (nonatomic, strong) UILabel *typeLabel;
//@property (nonatomic, strong) UIImageView *locationImgView;
@property (nonatomic, strong) UILabel *locationLabel;
//@property (nonatomic, strong) UIImageView *timeImgView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) ZZSnatchReceiveModel *model;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) dispatch_block_t touchSnatch;
@property (nonatomic, copy) dispatch_block_t touchLocation;

- (void)setData:(ZZSnatchReceiveModel *)model;

@end
