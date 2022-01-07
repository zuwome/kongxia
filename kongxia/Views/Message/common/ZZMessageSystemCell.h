//
//  ZZMessageSystemCell.h
//  zuwome
//
//  Created by angBiu on 16/7/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCConversation;
/**
 *  聊天列表系统消息cell
 */
@interface ZZMessageSystemCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLabel;//title
@property (nonatomic, strong) UILabel *unreadCountLabel;//未读


/**
 首次进入设置UI样式和未读数量

 @param dict UI样式的字典
 @param unReadDict 未读消息数量
 */
- (void)setMessageStyleWithIndexPath:(NSIndexPath *)indexPath uiDict:(NSDictionary *)dict unReadCountArray:(NSArray *) unReadArray kefuUnReadCount:(NSInteger)kFcount;



@end
