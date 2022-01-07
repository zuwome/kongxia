//
//  ZZChatBurnVersionView.h
//  zuwome
//
//  Created by angBiu on 2017/8/23.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 阅后即焚版本不可用
 */
@interface ZZChatBurnVersionView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSString *infoString;

- (void)show:(BOOL)animated;

- (void)dismiss;

@end
