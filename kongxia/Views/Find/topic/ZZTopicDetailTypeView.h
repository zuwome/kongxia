//
//  ZZTopicTypeView.h
//  zuwome
//
//  Created by angBiu on 2017/4/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZTopicDetailTypeView : UIView

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, copy) void(^selectIndex)(NSInteger index);

- (void)setIndex:(NSInteger)index;
- (void)setLineViewOffset:(CGFloat)offset;

@end
