//
//  ZZActivityCollectionCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTasks.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZZActivityCollectionCell : UICollectionViewCell

@property (nonatomic, copy) NSDictionary *activitityDic;

@end

@interface ZZActivityBtn: UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
