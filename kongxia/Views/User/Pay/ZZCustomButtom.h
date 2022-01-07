//
//  ZZCustomButtom.h
//  zuwome
//
//  Created by 潘杨 on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//一个按钮2个文字  1个图片
//我的钱包界面专属

#import <UIKit/UIKit.h>

@interface ZZCustomButtom : UIButton
@property (nonatomic,strong) UILabel *numMoneyLab;//数额
- (instancetype)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName titleName:(NSString *)titleName subtitleName:(NSString *)subtitle ;

@end
