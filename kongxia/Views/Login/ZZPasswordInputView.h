//
//  ZZPasswordInputView.h
//  zuwome
//
//  Created by angBiu on 2016/11/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  密码输入
 */
@interface ZZPasswordInputView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *hideBtn;
@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, copy) dispatch_block_t touchReturn;

@end
