//
//  ZZUserVideoEmptyView.h
//  zuwome
//
//  Created by angBiu on 2017/8/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZUserVideoEmptyView : UICollectionReusableView

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, assign) CGFloat topOffset;
@property (nonatomic, copy) dispatch_block_t touchRecord;

- (void)showViews;
- (void)hideViews;

@end
