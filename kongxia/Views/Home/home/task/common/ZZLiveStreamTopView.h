//
//  ZZLiveStreamTopView.h
//  zuwome
//
//  Created by angBiu on 2017/7/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZLiveStreamTopView : UIView

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) void(^selectedIndex)(NSInteger index);

- (void)snatchBtnClick;

@end
