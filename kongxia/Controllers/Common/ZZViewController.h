//
//  ZZViewController.h
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZZViewController : UIViewController

@property (nonatomic, strong) UIButton *navigationLeftBtn;
@property (nonatomic, strong) UIButton *navigationRightDoneBtn;

- (void)createNavigationLeftButton;
- (void)navigationLeftBtnClick;
- (void)createNavigationRightDoneBtn;
- (void)gotoLoginView;

@end
