//
//  ZZChatBoxGreetingCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/9/4.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ChatBoxGreetingCellId @"ChatBoxGreetingCellId"

typedef NS_ENUM(NSInteger, GreetingType) {
    GreetingTypeNormal = 0,
    GreetingTypeEdit,
};

@interface ZZChatBoxGreetingCell : UITableViewCell

@property (nonatomic, assign) GreetingType type;
@property (nonatomic, copy) void(^clickDelete)(void);
@property (nonatomic, copy) void(^clickEdit)(void);

@property (nonatomic, strong) UILabel *greeting;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@end
