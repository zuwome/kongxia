//
//  ZZFindHotHeadView.h
//  zuwome
//
//  Created by angBiu on 2017/4/27.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZFindHotTopicView.h"
#import "AdView.h"

@interface ZZFindHotHeadView : UIView

@property (nonatomic, strong) AdView *adView;
@property (nonatomic, strong) ZZFindHotTopicView *topicView;
@property (nonatomic, strong) UILabel *titleLabel;

- (instancetype)initWithFrame:(CGRect)frame array:(NSMutableArray *)array;

@end
