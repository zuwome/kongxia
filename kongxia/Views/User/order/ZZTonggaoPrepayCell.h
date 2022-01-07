//
//  ZZTonggaoPrepayCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/7/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTonggaoPrepayCell;
@protocol ZZTonggaoPrepayCellDelegate <NSObject>

- (void)cellShowProtocol:(ZZTonggaoPrepayCell *)cell;

@end

@interface ZZTonggaoPrepayCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZTonggaoPrepayCellDelegate> delegate;

@end
