//
//  ZZMessageHeadViewCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/7/24.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZMessageHeadViewCell : UICollectionViewCell

/**
 UI展示
 @param dict cell的title 和cell的image
 @param unReadArray 未读数量
 kFcount 客服的未读数量
 */
- (void)setMessageStyleWithIndexPath:(NSIndexPath *)indexPath uiDict:(NSDictionary *)dict unReadCountArray:(NSArray *)unReadArray;

//获取红点上未读数
- (NSString *)getUnreadCount;
//隐藏红点
- (void)hideUnreadLabel;

@end
