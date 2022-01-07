//
//  ZZNewOrderResonCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZInvitationModel.h"

/**
 自己的原因或者对方的原因调用的cell
 */
@interface ZZNewOrderResonCell : UITableViewCell

/**
 当前理由显示的cell
 */
@property(nonatomic,strong) ZZInvitationModel *model;
@end
