//
//  ZZRentOrderPriceView.h
//  zuwome
//
//  Created by qiming xiao on 2019/6/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RentPriceOptionType) {
    // 普通邀约
    RentPriceOptionTypeNormal = 1,
    
    // 优享邀约
    RentPriceOptionTypeBest,
};

@class ZZRentOrderPriceView;
@protocol ZZRentOrderPriceViewDelegate <NSObject>

- (void)viewShowBestDetailProtocols:(ZZRentOrderPriceView *)view;

- (void)view:(ZZRentOrderPriceView *)view showPriceDetails:(BOOL)isSelectBestDeal;

- (void)view:(ZZRentOrderPriceView *)view isSelectBestDeal:(BOOL)isSelectBestDeal;

- (void)confirm:(ZZRentOrderPriceView *)view;

@end

@class  ZZOrder;
@interface ZZRentOrderPriceView : UIView

@property (nonatomic, weak) id<ZZRentOrderPriceViewDelegate> delegate;

@property (nonatomic, strong) ZZOrder *order;

@property (nonatomic, assign) CGFloat totalHeight;

- (instancetype)initWithUser:(ZZUser *)user;

- (void)changeCurrentSelection:(RentPriceOptionType)type shouldShowProtocol:(BOOL)shouldShow isTheFirstTime:(BOOL)isTheFirstTime;

@end

@interface ZZRentOrderPriceOptionView : UIView

@property (nonatomic, assign) RentPriceOptionType type;

@property (nonatomic, strong) ZZOrder *order;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *prePayLabel;

@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, strong) UIImageView *priceInfoImageView;

- (instancetype)initWithType:(RentPriceOptionType)type;

@end

@interface ZZRentOrderPriceBottomBarItem : UIView

- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon;

@end
