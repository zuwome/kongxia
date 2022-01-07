//
//  ZZGiftItemCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/22.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZGiftModel;
@class ZZGiftItemsCell;

@protocol ZZGiftItemsCellDelegate <NSObject>

- (void)cell:(ZZGiftItemsCell *)view chooseGift:(ZZGiftModel *)giftModel;

@end

@interface ZZGiftItemsCell : UICollectionViewCell

@property (nonatomic, weak) id<ZZGiftItemsCellDelegate> delegate;

@property (nonatomic, strong) ZZGiftModel *selectedGiftModel;

- (void)configureGifts:(NSArray<ZZGiftModel *> *)giftsModelArr selectedGift:(ZZGiftModel *)selectedGiftModel;


@end

@interface ZZGiftItemView : UIView

- (void)configureGift:(ZZGiftModel *)model;

- (void)shouldShowSelectedView:(BOOL)shouldShow;

@end
