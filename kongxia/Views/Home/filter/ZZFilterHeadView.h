//
//  ZZFilterHeadView.h
//  zuwome
//
//  Created by angBiu on 16/8/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSelectView.h"

@interface ZZFilterHeadView : UIView

@property (nonatomic, strong) ZZSelectView *selectView;
@property (nonatomic, copy) dispatch_block_t touchInput;

@end
