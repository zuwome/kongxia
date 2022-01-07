//
//  ZZRentPageHeadCollectionViewCell.h
//  zuwome
//
//  Created by angBiu on 16/8/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  他人页头部cell
 */
@interface ZZRentPageHeadCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (copy, nonatomic) void(^imageCallBack)(UIImage *image);
@property (nonatomic, copy) void (^playVideo)(void);//播放达人视频

- (void)setUser:(ZZUser *)user indexPath:(NSIndexPath *)indexPath;

@end
