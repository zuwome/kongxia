//
//  ZZCommentInputCell.h
//  zuwome
//
//  Created by angBiu on 2017/4/6.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZCommentInputCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *countLabel;

@end
