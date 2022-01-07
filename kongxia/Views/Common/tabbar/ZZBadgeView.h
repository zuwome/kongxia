//
//  ZZBadgeView.h
//  zuwome
//
//  Created by angBiu on 16/8/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZBadgeView : UIView

@property (nonatomic, strong) UILabel *badgeLabel;

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) NSInteger count;

@end
