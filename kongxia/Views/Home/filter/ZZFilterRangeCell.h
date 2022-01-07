//
//  ZZFilterRangeCell.h
//  zuwome
//
//  Created by angBiu on 16/8/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NMRangeSlider.h>
#import "ZZFilterRangeBubbleView.h"
@class ZZFilterModel;

@interface ZZFilterRangeCell : UITableViewCell

@property (nonatomic, strong) ZZFilterRangeBubbleView *leftBubbleView;
@property (nonatomic, strong) ZZFilterRangeBubbleView *rightBubbleView;
@property (nonatomic, strong) NMRangeSlider *sliderView;
@property (nonatomic, copy) void(^sliderChange)(NSString *string);

- (void)setData:(ZZFilterModel *)model indexPath:(NSIndexPath *)indexPath;

@end
