//
//  ZZPublishOrderLocationCell.h
//  zuwome
//
//  Created by angBiu on 2017/7/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZPublishOrderNormalCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *leftLabel;

- (void)setData:(NSIndexPath *)indexPath skill:(ZZSkill *)skill param:(NSDictionary *)param;

@end
