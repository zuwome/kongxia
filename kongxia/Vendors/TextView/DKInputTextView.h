//
//  DKInputTextView.h
//  Cosmetic
//
//  Created by 余天龙 on 16/6/24.
//  Copyright © 2016年 YuTianLong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKInputTextView : UIView

/**
 *  placeholder text
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 *  Set the max text lenght . Default is 255 .
 */
@property (nonatomic, assign) NSUInteger textMaxLenght;

/**
 *  TextView Content
 */
@property (nonatomic, copy) NSString *text;

@end
