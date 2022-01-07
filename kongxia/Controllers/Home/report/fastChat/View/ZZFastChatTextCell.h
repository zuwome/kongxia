//
//  ZZFastChatTextCell.h
//  zuwome
//
//  Created by YuTianLong on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZFastChatTextCell : UITableViewCell

+ (NSString *)reuseIdentifier;

@property (nonatomic, strong) UILabel *rightLabel;

- (void)setupWithModel:(ZZUser *)model indexPath:(NSIndexPath *)indexPath;

@end
