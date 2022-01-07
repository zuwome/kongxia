//
//  ZZUserEditPhotoCell.h
//  zuwome
//
//  Created by angBiu on 2017/3/8.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCircleProgressView.h"
#import "ZZUserEditHeadView.h"
@class ZZUserEditHeadView;

@interface ZZUserEditPhotoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *coverBgView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIView *errorView;
@property (nonatomic, strong) UIImageView *errorImgView;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) ZZCircleProgressView *progressView;

@property (nonatomic, copy) dispatch_block_t touchSelf;

@property (nonatomic, assign) PhotoEditType type;

@end
