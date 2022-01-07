//
//  ZZMyWxView.h
//  zuwome
//
//  Created by angBiu on 2017/6/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZMyWxView : UIView

@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) dispatch_block_t touchGuide;
@property (nonatomic, copy) dispatch_block_t wxUpdate;
@property (nonatomic, copy) dispatch_block_t open_SanChat;//开通闪聊

@end
