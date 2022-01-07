//
//  ZZNewHomeNaviBar.h
//  naviTest
//
//  Created by MaoMinghui on 2018/8/15.
//  Copyright © 2018年 lql. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZNewHomeNaviBar : UIView

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) void(^touchLocation)(void); //点击位置
@property (nonatomic, copy) void(^touchSearch)(void);   //点击搜索

- (void)resetBtnStyle:(float)scale;

@end
