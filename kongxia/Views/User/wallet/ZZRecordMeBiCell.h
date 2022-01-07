//
//  ZZRecordMeBiCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/10.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZMeBiRecordModel.h"
#import "ZZRecord.h"
@interface ZZRecordMeBiCell : UITableViewCell
@property (nonatomic, strong) UILabel *timeLabel;//记录时间
@property (nonatomic, strong) UILabel *recordTitleLab;//作用
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) ZZMeBiRecordModel *recordModel;
@property (nonatomic, strong) ZZRecord *recordMoneyModel;
@end
