//
//  ZZCodeInputView.h
//  zuwome
//
//  Created by angBiu on 2016/11/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  验证码输入
 */
@interface ZZCodeInputView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *sendBtn;

@end
