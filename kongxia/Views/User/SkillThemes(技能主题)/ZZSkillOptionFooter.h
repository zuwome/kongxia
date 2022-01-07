//
//  ZZSkillOptionFooter.h
//  zuwome
//
//  Created by MaoMinghui on 2018/10/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SkillOptionFooterHeight 115

NS_ASSUME_NONNULL_BEGIN

@interface ZZSkillOptionFooter : UIView

@property (nonatomic, copy) void(^saveBtnClick)(void);
@property (nonatomic, copy) void(^deleteBtnClick)(void);

@end

NS_ASSUME_NONNULL_END
