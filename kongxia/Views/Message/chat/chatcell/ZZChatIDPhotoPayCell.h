//
//  ZZIDPhotoPayCell.h
//  zuwome
//
//  Created by qiming xiao on 2019/1/5.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIResponder+ZZRouter.h"
#import "ZZChatConst.h"
#import "ZZChatTimeView.h"
#import "ZZChatBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZChatIDPhotoPayCell : UITableViewCell

@property (nonatomic, strong) ZZChatTimeView *timeView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleCustomLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSString *uid;
- (void)setData:(ZZChatBaseModel *)model;

@end

NS_ASSUME_NONNULL_END
