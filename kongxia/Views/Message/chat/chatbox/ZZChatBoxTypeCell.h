//
//  ZZChatBoxTypeCell.h
//  zuwome
//
//  Created by angBiu on 2017/7/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZChatHelper.h"

@interface ZZChatBoxTypeCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

- (void)setData:(ChatBoxType)type selectedType:(ChatBoxType)selectedType isBurnReaded:(BOOL)isBurnReaded;

@end
