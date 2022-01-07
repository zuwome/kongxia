//
//  ZZCallRecordsCell.h
//  zuwome
//
//  Created by YuTianLong on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZCallRecordsModel;

@interface ZZCallRecordsCell : UITableViewCell

+ (NSString *)reuseIdentifier;

- (void)setupWithModel:(ZZCallRecordsModel *)model;

@end
