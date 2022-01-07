//
//  ZZNewHomeContentHeadView.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZNewHomeContentHeadView : UIView

@property (nonatomic, copy) dispatch_block_t nearByCallback;
@property (nonatomic, copy) dispatch_block_t recommendCallback;
@property (nonatomic, copy) dispatch_block_t freshCallback;

- (void)lineMoveToIndex:(NSInteger)index animated:(BOOL)animated;

@end
