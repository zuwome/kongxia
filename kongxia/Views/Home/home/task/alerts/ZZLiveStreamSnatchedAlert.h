//
//  ZZLiveStreamSnatchedView.h
//  zuwome
//
//  Created by angBiu on 2017/7/26.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZLiveStreamSnatchedAlert : UIView

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSDictionary *aDict;

@property (nonatomic, copy) void(^touchSure)(NSDictionary *aDict);

@end
