//
//  ZZPrivateLetterSwitchCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/9/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PrivateLetterSwitchCellId @"PrivateLetterSwitchCellId"

@interface ZZPrivateLetterSwitchCell : UITableViewCell

@property (nonatomic, strong) UILabel *contentLable;//内容
@property (nonatomic, strong) UILabel *promptLable;//提示
@property (nonatomic, strong) UISwitch *openSwitch;//开关

@end
