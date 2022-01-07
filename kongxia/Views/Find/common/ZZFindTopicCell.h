//
//  ZZFindTopicCell.h
//  zuwome
//
//  Created by angBiu on 2017/4/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZFindVideoModel.h"

@interface ZZFindTopicCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *peopleLabel;
@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) UIImageView *boomBgImgView;

- (void)setData:(ZZTopicGroupModel *)model;

@end
