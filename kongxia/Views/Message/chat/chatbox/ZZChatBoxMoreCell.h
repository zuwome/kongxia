//
//  ZZChatBoxMoreCell.h
//  zuwome
//
//  Created by angBiu on 16/10/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZChatHelper.h"
/**
 *  聊天 ---- 工具栏 --- 更多（+）cell
 */
@interface ZZChatBoxMoreCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setData:(NSNumber *)number;

@end
