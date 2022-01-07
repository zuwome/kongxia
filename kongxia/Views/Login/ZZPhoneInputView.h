//
//  ZZPhoneInputView.h
//  zuwome
//
//  Created by angBiu on 2016/11/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  手机号输入
 */
@interface ZZPhoneInputView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, copy) dispatch_block_t touchCode;


- (instancetype)initWithFrame:(CGRect)frame showBingdinView:(BOOL)showBingdinView;
@end
