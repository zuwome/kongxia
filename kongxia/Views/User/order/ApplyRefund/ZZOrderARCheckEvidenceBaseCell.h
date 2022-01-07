//
//  ZZOrderARCheckEvidenceBaseCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZUploadBaseModel.h"
/**
 查看证据的基类
 */
@interface ZZOrderARCheckEvidenceBaseCell : UITableViewCell


/**
 分割线
 */
@property(nonatomic,strong) UIView *lineView;

- (void)setShowTitle:(NSString *)title detailTitle:(NSString *)detailTitle dataArray:(NSArray*)array viewController:(UIViewController *)viewController ;
@end
