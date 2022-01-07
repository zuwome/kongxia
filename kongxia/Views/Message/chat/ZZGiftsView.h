//
//  ZZGiftsView.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/22.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZGiftHelper.h"

@class ZZGiftModel;
@class ZZGiftsView;

@protocol ZZGiftsViewDelegate <NSObject>

- (void)giftView:(ZZGiftsView *)view chooseGift:(ZZGiftModel *)giftModel;

@end

@interface ZZGiftsView : UIView

@property (nonatomic, weak) UIViewController *parentVC;

@property (nonatomic, weak) id<ZZGiftsViewDelegate> delegate;

@property (nonatomic, strong) ZZGiftHelper *giftHelper;

- (void)show;

- (void)hide;

@end

