//
//  ZZPublishOrderSexCell.h
//  zuwome
//
//  Created by angBiu on 2017/7/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

//性别cell
@interface ZZPublishOrderSexCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, copy) void(^selectedIndex)(NSInteger index);

@end
