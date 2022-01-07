//
//  ZZUserCentRespondCell.h
//  zuwome
//
//  Created by angBiu on 2017/4/10.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZUserCenterRespondItemView.h"

/**
 我是达人 ---- 响应数据cell
 */
@interface ZZUserCenterRespondCell : UITableViewCell

@property (nonatomic, strong) ZZUserCenterRespondItemView *readView;
@property (nonatomic, strong) ZZUserCenterRespondItemView *appointmentView;
@property (nonatomic, strong) ZZUserCenterRespondItemView *respondPercentView;

- (void)setData:(ZZUser *)user;

@end
