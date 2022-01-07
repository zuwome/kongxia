//
//  ZZRecordFullInfoCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/26.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"

@class ZZRecordFullInfoCell;
@class ZZRecord;
@class ZZMeBiRecordModel;

@protocol ZZRecordFullInfoCellDelegate<NSObject>

- (void)cell:(ZZRecordFullInfoCell *)cell showUserInfo:(ZZUser *)user;

@end

@interface ZZRecordFullInfoCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZRecordFullInfoCellDelegate> delegate;

@property (nonatomic, strong) ZZRecord *recordMoneyModel;

@property (nonatomic, strong) ZZMeBiRecordModel *mebiModel;

@end

