//
//  ZZRentWXCell.h
//  zuwome
//
//  Created by angBiu on 2017/6/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZRentWXCell;
@protocol ZZRentWXCellDelegate <NSObject>

- (void)cellShowAssistance:(ZZRentWXCell *)cell;

@end

@interface ZZRentWXCell : UITableViewCell

@property (nonatomic, weak) id<ZZRentWXCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *readBtn;
@property (nonatomic, strong) UILabel *assistContentLabel;
@property (nonatomic, strong) UIButton *assistBtn;
@property (nonatomic, strong) UIImageView *assistImageView;
- (void)setData:(ZZUser *)user;

@end
