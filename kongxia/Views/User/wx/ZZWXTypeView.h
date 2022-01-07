//
//  ZZWXTypeView.h
//  zuwome
//
//  Created by angBiu on 2017/6/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZLineView.h"

@interface ZZWXTypeView : UIView

@property (nonatomic, strong) ZZLineView *lineView;
@property (nonatomic, copy) dispatch_block_t touchLeft;
@property (nonatomic, copy) void(^selectIndex)(NSInteger index);

- (void)setLineViewOffset:(CGFloat)offset;
- (void)setLineIndex:(NSInteger)index;


@end
