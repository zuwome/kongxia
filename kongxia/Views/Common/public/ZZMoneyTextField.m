//
//  ZZMoneyTextField.m
//  zuwome
//
//  Created by angBiu on 2016/11/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMoneyTextField.h"

@implementation ZZMoneyTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _lastStr = @"";
        
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.returnKeyType = UIReturnKeyDone;
        self.delegate = self;
        
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return self;
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    if (textField.text.length > _lastStr.length)
    {
        NSString *str = [textField.text stringByReplacingOccurrencesOfString:_lastStr withString:@""];
        BOOL isPure = [ZZUtils isPureInt:str];
        if (!isPure && ![str isEqualToString:@"."])
        {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:str withString:@""];
        }
    }
    
    if (textField.text.length>10)
    {
        textField.text = [textField.text substringToIndex:10];
    }
    
    _amount = [NSNumber numberWithFloat:[textField.text floatValue]];
    _lastStr = textField.text;
    
    if (_valueChanged) {
        _valueChanged();
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _amount = [NSNumber numberWithFloat:[textField.text floatValue]];
    
    if (!_noEndEditing) {
        [self endEditing:YES];
    }
    if (_touchReturn) {
        _touchReturn();
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [ZZUtils limitTextFieldWithTextField:textField range:range replacementString:string pure:_pure];
}

@end
