//
//  ZZCommentStarCell.h
//  zuwome
//
//  Created by angBiu on 2017/4/6.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZStarsView.h"

@interface ZZCommentStarCell : UITableViewCell <ZZStarsViewDelegate>

@property (nonatomic, strong) ZZStarsView *starView;
@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, copy) void(^currentScore)(int score);

@end
