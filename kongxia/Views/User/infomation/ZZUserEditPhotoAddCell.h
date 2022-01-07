//
//  ZZUserEditPhotoAddCell.h
//  zuwome
//
//  Created by angBiu on 2017/3/8.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZUserEditHeadView.h"
@class ZZUserEditHeadView;

@interface ZZUserEditPhotoAddCell : UICollectionViewCell

@property (nonatomic, copy) dispatch_block_t touchSelf;
@property (nonatomic, assign) PhotoEditType type;

@end
