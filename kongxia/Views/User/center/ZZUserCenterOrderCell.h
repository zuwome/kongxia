//
//  ZZUserCenterOrderCell.h
//  zuwome
//
//  Created by angBiu on 16/8/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSelfOrderButton.h"
/**
 *  我的档期 cell
 */
@interface ZZUserCenterOrderCell : UITableViewCell

@property (nonatomic, strong) ZZSelfOrderButton *ingBtn;
@property (nonatomic, strong) ZZSelfOrderButton *commentBtn;
@property (nonatomic, strong) ZZSelfOrderButton *doneBtn;
@property (nonatomic, copy) void(^selectOrder)(NSInteger index);

- (void)setData;

@end
