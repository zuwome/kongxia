//
//  ZZTaskActionsCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZTaksListViewModel.h"

@class ZZTaskActionsCell;
@protocol ZZTaskActionsCellDelegate <NSObject>

- (void)cell:(ZZTaskActionsCell *)cell likeActionWithItem:(TaskActionsItem *)item;

- (void)cell:(ZZTaskActionsCell *)cell chatWithItem:(TaskActionsItem *)item;

- (void)cell:(ZZTaskActionsCell *)cell signUpActionWith:(TaskActionsItem *)item;

- (void)cell:(ZZTaskActionsCell *)cell rent:(TaskActionsItem *)item;

- (void)cell:(ZZTaskActionsCell *)cell checkWechat:(TaskActionsItem *)item;

@end

@interface ZZTaskActionsCell : ZZTableViewCell

@property (nonatomic, weak) id<ZZTaskActionsCellDelegate> delegate;

@property (nonatomic, strong) TaskItem *item;

@end

@interface buttonView : UIView

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

