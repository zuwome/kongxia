//
//  ZZUserCenterCountCell.h
//  zuwome
//
//  Created by angBiu on 16/10/10.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  我 ---- 粉丝数、关注数、等级
 */
@interface ZZUserCenterCountCell : UITableViewCell

@property (nonatomic, strong) UILabel *attentCountLabel;
@property (nonatomic, strong) UILabel *fansCountLabel;
@property (nonatomic, strong) UILabel *levelCountLabel;

@property (nonatomic, copy) dispatch_block_t touchAttent;
@property (nonatomic, copy) dispatch_block_t touchFans;
@property (nonatomic, copy) dispatch_block_t touchLevel;

- (void)setData:(ZZUser *)user;

@end
