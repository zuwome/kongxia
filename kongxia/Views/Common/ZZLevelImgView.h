//
//  ZZLevelImgView.h
//  zuwome
//
//  Created by angBiu on 2016/10/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  等级view
 */
@interface ZZLevelImgView : UIImageView

@property (nonatomic, strong) UILabel *levelLabel;

- (void)setLevel:(NSInteger)level;

@end
