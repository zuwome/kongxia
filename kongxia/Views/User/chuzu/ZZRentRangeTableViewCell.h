//
//  ZZRentRangeTableViewCell.h
//  zuwome
//
//  Created by wlsy on 16/1/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZRentRangeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *wrapperView;
@property (copy, nonatomic) void(^tapDeleteNext)(UIButton *sender);

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
