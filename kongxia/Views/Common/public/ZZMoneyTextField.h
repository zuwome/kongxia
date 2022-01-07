//
//  ZZMoneyTextField.h
//  zuwome
//
//  Created by angBiu on 2016/11/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZMoneyTextField : UITextField <UITextFieldDelegate>

@property (nonatomic, strong) NSString *lastStr;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, assign) BOOL pure;

@property (nonatomic, assign) BOOL noEndEditing;

@property (nonatomic, copy) dispatch_block_t valueChanged;
@property (nonatomic, copy) dispatch_block_t touchReturn;

@end
