//
//  ZZSelectView.h
//  zuwome
//
//  Created by wlsy on 16/1/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZSelectView : UICollectionView

@property (strong, nonatomic) NSArray *options;
@property (copy, nonatomic) void(^didSeletedOptions)(NSMutableArray *opts);

@end
