//
//  ZZKTVGiftsView.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/9.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZGiftHelper.h"

@class ZZGiftModel;
@class ZZKTVGiftsView;

@protocol ZZKTVGiftsViewDelegate <NSObject>

- (void)giftView:(ZZKTVGiftsView *)view chooseGift:(ZZGiftModel *)giftModel;

@end

@interface ZZKTVGiftsView : UIView

@property (nonatomic, weak) UIViewController *parentVC;

@property (nonatomic, strong) ZZGiftHelper *giftHelper;

@property (nonatomic, weak) id<ZZKTVGiftsViewDelegate> delegate;

- (void)show;

- (void)hide;

@end

