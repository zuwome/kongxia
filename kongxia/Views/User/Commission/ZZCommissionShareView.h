//
//  ZZCommissionShareView.h
//  kongxia
//
//  Created by qiming xiao on 2019/10/9.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommissionConfig.h"
@class ZZCommissionModel;


@interface ZZCommissionShareView : UIView

@property (nonatomic, strong) ZZCommissionModel *commissionModel;

- (instancetype)initWithInfoModel:(ZZCommissionModel *)model frame:(CGRect)frame entry:(CommissionChannelEntry)entry;

- (instancetype)initWithInfoModel:(ZZCommissionModel *)model user:(ZZUser *)user frame:(CGRect)frame entry:(CommissionChannelEntry)entry;

- (UIImage *)cutFromView:(UIView *)view;

@end


@interface ZZCommissionQRCodeView : UIView

- (instancetype)initWithCommissionModel:(ZZCommissionModel *)model user:(ZZUser *)user entry:(CommissionChannelEntry)entry;

- (instancetype)initWithCommissionModel:(ZZCommissionModel *)model user:(ZZUser *)user frame:(CGRect)frame;

- (UIImage *)cutFromView;

@end


@class ZZCommissionShareChannelView;

@protocol ZZCommissionShareChannelViewDelegate <NSObject>

- (void)view:(ZZCommissionShareChannelView *)view didChooseChannel:(CommissionChannel)channel;

@end


@interface ZZCommissionShareChannelView : UIView

@property (nonatomic, weak) id<ZZCommissionShareChannelViewDelegate> delegate;

@property (nonatomic, strong) UIButton *cancelBtn;

@end
