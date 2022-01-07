//
//  ZZChuzuReusableView.h
//  zuwome
//
//  Created by angBiu on 2016/11/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZMoneyTextField.h"
/**
 *  出租 --技能选择 头部
 */
@interface ZZChuzuReusableView : UICollectionReusableView

@property (nonatomic, strong) ZZMoneyTextField *textField;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, assign) BOOL showInfo;
@property (nonatomic, copy) dispatch_block_t textChange;

- (void)setPriceValue;

@end
