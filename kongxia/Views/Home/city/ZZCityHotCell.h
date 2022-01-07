//
//  ZZCityHotCell.h
//  zuwome
//
//  Created by angBiu on 16/7/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKTagView;
/**
 *  首页城市 热门cell
 */
@interface ZZCityHotCell : UITableViewCell

@property (nonatomic, strong) SKTagView *tagView;
@property (nonatomic, copy) void(^selectIndex)(NSInteger index);

- (void)setData:(NSArray *)array;

@end
