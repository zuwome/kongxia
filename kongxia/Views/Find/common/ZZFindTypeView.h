//
//  ZZFindTypeView.h
//  zuwome
//
//  Created by angBiu on 16/8/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZLineView.h"

@interface ZZFindTypeView : UIView

@property (nonatomic, strong) ZZLineView *lineView;
@property (nonatomic, strong) UIView *rightRedPointView;
@property (nonatomic, copy) void(^selectIndex)(NSInteger index);
@property (nonatomic, strong) NSMutableArray<UIButton *> *btns;

- (void)setLineViewOffset:(CGFloat)offset;
- (void)setLineIndex:(NSInteger)index;

@end
