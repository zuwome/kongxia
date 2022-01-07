//
//  ZZChatVoiceHud.h
//  zuwome
//
//  Created by angBiu on 16/10/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZChatVoiceHud : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGFloat progress;

- (void)setShortImage;
- (void)resetImage;
- (void)setCancelImage;

@end
