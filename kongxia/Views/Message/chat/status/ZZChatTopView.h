//
//  ZZChatTopView.h
//  zuwome
//
//  Created by angBiu on 2017/4/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZChatTopView : UIView

@property (nonatomic, strong) UILabel *skillLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *rentBtn;
@property (nonatomic, strong) ZZUser *user;

@property (nonatomic, copy) dispatch_block_t touchRent;

@end
