//
//  ZZTaskMoneyInputView.h
//  zuwome
//
//  Created by angBiu on 2017/8/5.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZMoneyTextField.h"
@class ZZTaskMoneyInputView;

@protocol ZZTaskMoneyInputVieDelegate <NSObject>

- (void)inputView:(ZZTaskMoneyInputView *)inputView price:(NSString *)price;

@end

@interface ZZTaskMoneyInputView : UIView

@property (nonatomic, strong) ZZMoneyTextField *textField;
@property (nonatomic, assign) NSInteger hour;

@property (nonatomic, weak) id<ZZTaskMoneyInputVieDelegate>delegate;

@end
