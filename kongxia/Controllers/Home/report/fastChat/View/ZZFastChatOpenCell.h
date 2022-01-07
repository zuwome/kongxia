//
//  ZZFastChatOpenCell.h
//  zuwome
//
//  Created by YuTianLong on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZFastChatOpenCell : UITableViewCell
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic,strong) UILabel *promptLable;//提示
+ (NSString *)reuseIdentifier;

@property (nonatomic, strong) UISwitch *openSwitch;

- (void)setupWithModel:(ZZUser *)model;

@end
