//
//  ZZFastChatCell.h
//  zuwome
//
//  Created by YuTianLong on 2017/12/28.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZFastChatModel;

@interface ZZFastChatCell : UITableViewCell

+ (NSString *)reuseIdentifier;

- (void)setupWithModel:(ZZFastChatModel *)model;

@property (nonatomic, copy) void (^fastChatBlock)(void);

@end
